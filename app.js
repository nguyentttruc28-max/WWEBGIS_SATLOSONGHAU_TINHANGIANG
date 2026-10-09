// app.js
// WEB GIS quản lý sạt lở sông Hậu đoạn qua tỉnh An Giang
// Luồng: EJS -> Express -> PostgreSQL/PostGIS -> JSON -> Leaflet/Chart.js.

const fs = require("fs");
const path = require("path");
const express = require("express");
const session = require("express-session");
const dotenv = require("dotenv");
const { Pool } = require("pg");

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const hasDatabase = Boolean(process.env.DATABASE_URL);
const pool = hasDatabase
  ? new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: process.env.DATABASE_URL.includes("localhost")
        ? false
        : { rejectUnauthorized: false },
      connectionTimeoutMillis: 5000
    })
  : null;

const DEMO_USER = { username: "demo123", password: "demo123", displayName: "Tài khoản demo" };
const fallbackPath = path.join(__dirname, "data", "satlo_incident_v4_1.json");

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.set("trust proxy", 1);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));
app.use(session({
  secret: process.env.SESSION_SECRET || "webgis-angiang-dev-secret",
  resave: false,
  saveUninitialized: false,
  cookie: { httpOnly: true, secure: process.env.NODE_ENV === "production", maxAge: 8 * 60 * 60 * 1000 }
}));

function requireAuth(req, res, next) {
  if (req.session && req.session.user) return next();
  if (req.is("application/json") || req.xhr) return res.status(401).json({ ok: false, message: "Chưa đăng nhập." });
  return res.redirect("/login");
}

function loadFallbackData() {
  return JSON.parse(fs.readFileSync(fallbackPath, "utf8"));
}

// Phân loại hiển thị được lấy trực tiếp từ trường severity_level của bộ dữ liệu V4.1.
// Không suy diễn lại mức độ và không thay thế cấp cảnh báo chính thức.
async function initialiseDatabaseIfRequested() {
  if (!pool || process.env.AUTO_INIT_DB !== "true") return;
  try {
    const exists = await pool.query("SELECT to_regclass('public.satlo_incident') AS table_name");
    if (!exists.rows[0].table_name) {
      const initSql = fs.readFileSync(path.join(__dirname, "db", "init.sql"), "utf8");
      const schemaSql = fs.readFileSync(path.join(__dirname, "db", "schema.sql"), "utf8");
      const seedSql = fs.readFileSync(path.join(__dirname, "db", "seed.sql"), "utf8");
      await pool.query(initSql);
      await pool.query(schemaSql);
      await pool.query(seedSql);
      console.log("PostgreSQL/PostGIS: đã khởi tạo schema + dữ liệu V4.1 từ db/schema.sql và db/seed.sql");
    }
  } catch (err) {
    console.error("PostgreSQL AUTO_INIT_DB lỗi:", err.message);
  }
}


async function queryManagementData() {
  if (!pool) return { data: loadManagementFallback(), source: "local-fallback" };
  const [works, residential, roads] = await Promise.all([
    pool.query(`SELECT w.id_work AS id, w.name, w.work_type AS type, w.status, w.locality, w.district_historical AS district, NULL::int AS year, NULL::numeric AS lat, NULL::numeric AS lng, 'Chưa công bố trong bộ dữ liệu V4' AS "coordinateStatus", r.provider AS source, r.reference_url AS "sourceUrl", 'Bộ dữ liệu V4 không cung cấp tọa độ cho công trình.' AS note FROM management_work w LEFT JOIN reference_source r ON r.id_reference=w.id_reference ORDER BY w.id_work`),
    pool.query(`SELECT a.id_residential AS id, a.incident_code AS name, a.impact_status AS type, NULL::int AS year, NULL::numeric AS lat, NULL::numeric AS lng, a.households, NULL::int AS "housesCollapsed", NULL::int AS "housesRelocated", 'Chưa công bố trong bộ dữ liệu V4' AS "coordinateStatus", r.provider AS source, r.reference_url AS "sourceUrl", a.impact_status AS note FROM affected_residential a LEFT JOIN reference_source r ON r.id_reference=a.id_reference ORDER BY a.id_residential`),
    pool.query(`SELECT a.id_road AS id, a.incident_code AS "incidentCode", a.road_type AS name, a.impact_detail AS type, NULL::int AS year, NULL::numeric AS lat, NULL::numeric AS lng, 'Chưa công bố trong bộ dữ liệu V4' AS "coordinateStatus", r.provider AS source, r.reference_url AS "sourceUrl", a.impact_detail AS note FROM affected_road a LEFT JOIN reference_source r ON r.id_reference=a.id_reference ORDER BY a.id_road`)
  ]);
  return { data: { works: works.rows, residential: residential.rows, roads: roads.rows }, source: "postgresql" };
}
function loadManagementFallback() {
  return JSON.parse(fs.readFileSync(path.join(__dirname, "data", "management_v4_1.json"), "utf8"));
}

async function querySatLoData() {
  if (!pool) return { rows: loadFallbackData(), source: "local-fallback" };
  const result = await pool.query(`
    SELECT
      s.incident_code AS id,
      s.river_section AS "viTri",
      s.commune AS xa,
      s.locality,
      s.district_historical AS huyen,
      EXTRACT(YEAR FROM s.observed_date)::int AS year,
      TO_CHAR(s.observed_date, 'YYYY-MM-DD') AS date,
      CASE WHEN s.length_m ~ '^[0-9]+(\\.[0-9]+)?$' THEN (s.length_m::numeric / 1000.0) ELSE NULL END AS length,
      s.length_m,
      s.bank_inland_m AS "bankInland",
      s.affected_households AS households,
      s.latitude AS lat,
      s.longitude AS lng,
      s.latitude_reference AS "latitudeReference",
      s.longitude_reference AS "longitudeReference",
      s.coordinate_status AS "coordinateStatus",
      s.impact_summary AS "impactSummary",
      s.verification_status AS "verificationStatus",
      s.severity_level AS risk,
      s.severity_score AS "severityScore",
      s.classification_basis AS "classificationBasis",
      s.classification_confidence AS "classificationConfidence",
      s.classification_evidence AS "classificationEvidence",
      s.classification_method AS "classificationMethod",
      s.source_warning_level AS "warningLevel",
      r.reference_name AS "sourceName",
      r.provider AS source,
      r.reference_url AS "sourceUrl",
      COALESCE(iwl.note, 'Nguồn sự kiện chưa có liên kết cảnh báo theo năm.') AS "warningNote"
    FROM satlo_incident s
    LEFT JOIN incident_warning_link iwl ON iwl.incident_code = s.incident_code
    LEFT JOIN reference_source r ON r.id_reference = s.id_reference
    ORDER BY s.observed_date, s.incident_code
  `);
  return { rows: result.rows.map(row => ({
    ...row,
    risk: row.risk || "Chưa phân loại",
    warningLevel: row.warningLevel || "Chưa phân loại",
    warningNote: row.warningNote || "Nguồn sự kiện chưa có liên kết cảnh báo theo năm."
  })), source: "postgresql" };
}

app.get("/", (req, res) => req.session?.user ? res.redirect("/dashboard") : res.redirect("/login"));
app.get("/login", (req, res) => {
  if (req.session?.user) return res.redirect("/dashboard");
  res.render("login", { title: "Đăng nhập WebGIS", error: req.query.error === "1" ? "Sai tên người dùng hoặc mật khẩu." : null });
});
app.post("/login", (req, res) => {
  const { username, password } = req.body || {};
  if (username === DEMO_USER.username && password === DEMO_USER.password) {
    req.session.user = { username: DEMO_USER.username, displayName: DEMO_USER.displayName };
    return res.redirect("/dashboard");
  }
  return res.redirect("/login?error=1");
});
app.post("/logout", (req, res) => req.session.destroy(() => res.redirect("/login")));

app.get("/dashboard", requireAuth, (req, res) => res.render("dashboard", { title: "WEB GIS QUẢN LÝ SẠT LỞ SÔNG HẬU", user: req.session.user.displayName }));
app.get("/data", requireAuth, (req, res) => res.render("data", { title: "Dữ liệu sạt lở – WebGIS sông Hậu", user: req.session.user.displayName }));
app.get("/overview", requireAuth, (req, res) => res.render("overview", { title: "Tổng quan sạt lở – WebGIS sông Hậu", user: req.session.user.displayName }));
app.get("/guide", requireAuth, (req, res) => res.render("hsng", { title: "Hướng dẫn sử dụng WebGIS", user: req.session.user.displayName }));

app.get("/api/satlo-data", requireAuth, async (req, res) => {
  try {
    const data = await querySatLoData();
    res.set("X-WebGIS-Data-Source", data.source);
    res.json(data.rows);
  } catch (err) {
    console.error("PostgreSQL query lỗi:", err.message);
    // Nếu PostgreSQL tạm thời chưa kết nối, bản đồ vẫn hiển thị bộ dữ liệu đã kiểm chứng đi kèm project.
    try {
      res.set("X-WebGIS-Data-Source", "local-fallback");
      res.json(loadFallbackData());
    } catch (fallbackErr) {
      res.status(500).json({ error: "Database error", detail: err.message });
    }
  }
});


app.get("/api/management", requireAuth, async (req, res) => {
  try {
    const result = await queryManagementData();
    res.set("X-WebGIS-Data-Source", result.source);
    res.json(result.data);
  } catch (err) {
    console.error("PostgreSQL management query lỗi:", err.message);
    res.set("X-WebGIS-Data-Source", "local-fallback");
    res.json(loadManagementFallback());
  }
});

app.get("/api/stats", requireAuth, async (req, res) => {
  try {
    const data = await querySatLoData();
    const rows = data.rows;
    res.json({
      total_points: rows.length,
      total_length: rows.reduce((s, d) => s + (Number(d.length) || 0), 0),
      high_points: rows.filter(d => d.risk === "Nguy hiểm" || d.risk === "Đặc biệt nguy hiểm").length,
      affected_households: rows.reduce((s, d) => s + (Number(d.households) || 0), 0),
      source: data.source
    });
  } catch (err) {
    res.status(500).json({ error: "Database error", detail: err.message });
  }
});

app.get("/api/health", async (req, res) => {
  if (!pool) return res.json({ status: "ok", database: "not_configured", data_fallback: true });
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ok", database: "connected", data_fallback: false });
  } catch (err) {
    res.status(200).json({ status: "degraded", database: "not_connected", data_fallback: true });
  }
});

app.listen(PORT, () => console.log(`WebGIS đang chạy tại http://localhost:${PORT}`));
initialiseDatabaseIfRequested();
