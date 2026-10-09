// Khởi tạo Leaflet, basemap và các lớp quản lý.
// Tọa độ nguồn của V4.1 được giữ nguyên; display_coordinates.json chỉ cung cấp tọa độ đại diện để trực quan hóa khi nguồn chưa công bố GPS.

const AN_GIANG_CENTER = [10.55, 105.28];
const AN_GIANG_BOUNDS = [[10.38, 105.05], [10.88, 105.52]];
const map = L.map("map", { zoomControl: false, preferCanvas: true }).setView(AN_GIANG_CENTER, 10);
L.control.zoom({ position: "bottomright" }).addTo(map);

const street = L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  maxZoom: 19,
  attribution: "© OpenStreetMap contributors"
});
const satellite = L.tileLayer("https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}", {
  maxZoom: 19,
  maxNativeZoom: 17,
  noWrap: true,
  attribution: "Tiles © Esri — Source: Esri, Maxar, Earthstar Geographics"
});

// Mặc định dùng bản đồ đường phố để khi đăng nhập người dùng thấy ngay khu vực An Giang.
street.addTo(map);

// Lớp Sông Hậu chi tiết: shapefile được đóng gói trong public/river/
// và chuyển sang GeoJSON để Leaflet hiển thị trên trình duyệt.
const riverHau = L.layerGroup();
let riverHauLoaded = false;

async function loadRiverHauLayer() {
  if (riverHauLoaded) return true;
  const response = await fetch('/river/song_hau_detailed.geojson', { headers: { 'Accept': 'application/json' } });
  if (!response.ok) throw new Error('Không thể đọc lớp Sông Hậu');
  const geojson = await response.json();
  L.geoJSON(geojson, {
    style: feature => {
      const name = String(feature?.properties?.ten_song || 'Sông Hậu');
      const isMain = name === 'Sông Hậu';
      return {
        color: isMain ? '#145da0' : '#4f86b5',
        weight: isMain ? 5 : 3.2,
        opacity: isMain ? 0.95 : 0.88,
        lineCap: 'round',
        lineJoin: 'round'
      };
    },
    onEachFeature: (feature, layer) => {
      layer.bindPopup(`
        <div class="map-popup">
          <div class="popup-head"><b>${escapeHtml(feature?.properties?.ten_song || 'Sông Hậu')}</b><span class="management-tag">Lớp đường sông</span></div>
          <div class="popup-note">
            <b>Loại:</b> ${escapeHtml(feature?.properties?.loai || 'Đường sông')}<br>
            <b>Nguồn:</b> ${escapeHtml(feature?.properties?.nguon || 'OpenStreetMap / WaterwayMap')}<br>
            <b>Hệ tọa độ:</b> WGS 84 (EPSG:4326)<br>
            <b>Lưu ý:</b> hình học là đường thủy/đường tâm từ dữ liệu OpenStreetMap được WaterwayMap công bố; không phải ranh giới bờ sông hay dữ liệu đo đạc hiện trường.
          </div>
        </div>`);
    }
  }).addTo(riverHau);
  riverHauLoaded = true;
  return true;
}

const displayCoordinates = {
  "Bình Tân": [10.551389, 105.275833],
  "Quốc Khánh": [10.909167, 105.078611],
  "Phú Thành": [10.918056, 105.092222],
  "Vĩnh Phước": [10.918056, 105.092222],
  "An Thái": [10.414722, 105.455833],
  "Hòa Lộc và Hòa Hưng 1": [10.693557, 105.196626],
  "Hòa An": [10.671000, 105.221300],
  "Mỹ Thuận": [10.437222, 105.417500],
  "Mỹ Khánh 1": [10.420000, 105.416389],
  "Vĩnh Phú": [10.594444, 105.215278],
  "Châu Phong": [10.715556, 105.146667],
  "Châu Phú": [10.581000, 105.212000],
  "Vĩnh Thạnh Trung - Bình Mỹ": [10.572917, 105.245556],
  "Quốc Thái": [10.91654, 105.08295],
  "Quốc Khánh": [10.91654, 105.08295]
};

function getDisplayCoordinate(record) {
  const actualLat = Number(record?.lat);
  const actualLng = Number(record?.lng);
  if (Number.isFinite(actualLat) && Number.isFinite(actualLng) && actualLat !== 0 && actualLng !== 0) {
    return { lat: actualLat, lng: actualLng, type: "Tọa độ theo dữ liệu nguồn" };
  }
  const locality = String(record?.locality || "").trim();
  const exact = displayCoordinates[locality];
  if (exact) return { lat: exact[0], lng: exact[1], type: "Tọa độ đại diện theo địa bàn" };
  const commune = String(record?.xa || "").trim();
  if (displayCoordinates[commune]) return { lat: displayCoordinates[commune][0], lng: displayCoordinates[commune][1], type: "Tọa độ đại diện theo địa bàn" };
  return null;
}

const layers = {
  risk: L.layerGroup().addTo(map),
  riverHau,
  works: L.layerGroup(),
  residential: L.layerGroup(),
  roads: L.layerGroup()
};

const riskColor = {
  "Đặc biệt nguy hiểm": "#b4232d",
  "Nguy hiểm": "#e56b32",
  "Bình thường": "#31a46a",
  "Chưa phân loại": "#e85aad"
};

const managementStyle = {
  works: { color: "#0c2d4f", fill: "#0c2d4f", label: "Công trình phòng, chống sạt lở" },
  residential: { color: "#8a3f0b", fill: "#d97706", label: "Khu dân cư bị ảnh hưởng" },
  roads: { color: "#6b4f00", fill: "#f2c94c", label: "Giao thông bị đe dọa" }
};

function escapeHtml(value) {
  return String(value ?? "").replace(/[&<>'"]/g, ch => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", "'": "&#39;", '"': "&quot;"
  }[ch]));
}

function managementIcon(kind) {
  const icons = {
    works: "🚧",
    residential: "🌆",
    roads: "🛣️"
  };
  return L.divIcon({
    className: `management-icon management-${kind}`,
    html: `<span class="management-emoji" aria-label="${escapeHtml(managementStyle[kind].label)}">${icons[kind]}</span>`,
    iconSize: [32, 32],
    iconAnchor: [16, 30],
    popupAnchor: [0, -28]
  });
}

function popupHTML(d) {
  const risk = escapeHtml(d.risk);
  const color = riskColor[d.risk] || "#64748b";
  return `<div class="map-popup">
    <div class="popup-head"><b>${escapeHtml(d.id)}</b><span class="popup-risk" style="background:${color}">${risk}</span></div>
    <div class="popup-location">${escapeHtml(d.viTri)}</div>
    <table>
      <tr><td>Địa bàn</td><td><b>${escapeHtml(d.xa)}, ${escapeHtml(d.huyen)}</b></td></tr>
      <tr><td>Năm</td><td>${escapeHtml(d.year)}</td></tr>
      <tr><td>Chiều dài</td><td>${d.length == null ? "Chưa công bố" : Number(d.length).toFixed(3) + " km"}</td></tr>
      <tr><td>Hộ ảnh hưởng</td><td>${d.households == null ? "Chưa công bố" : escapeHtml(d.households)}</td></tr>
      <tr><td>Ngày ghi nhận</td><td>${escapeHtml(d.date || "Chưa công bố")}</td></tr>
    </table>
    <div class="popup-note">
      <b>Vị trí hiển thị:</b> ${escapeHtml(d.displayCoordinateType || d.coordinateStatus || "Chưa có tọa độ")}<br>
      <b>Điểm phân loại:</b> ${d.severityScore == null ? "Chưa có" : escapeHtml(d.severityScore) + "/100"}<br>
      <b>Cơ sở phân loại:</b> ${escapeHtml(d.classificationBasis || "Chưa có")}<br>
      <b>Độ tin cậy:</b> ${escapeHtml(d.classificationConfidence || "Chưa có")}<br>
      <b>Bằng chứng:</b> ${escapeHtml(d.classificationEvidence || "Chưa có")}<br>
      <b>Nguồn:</b> ${escapeHtml(d.source || "Chưa công bố")}<br>
      <a href="${escapeHtml(d.sourceUrl || "#")}" target="_blank" rel="noopener">Mở nguồn gốc</a><br>
      <b>Tọa độ:</b> ${escapeHtml(d.coordinateStatus || "Chưa công bố")}<br>
      <b>Mức cảnh báo nguồn:</b> ${escapeHtml(d.warningLevel || "Chưa phân loại")}<br>
      <b>Phương pháp:</b> ${escapeHtml(d.classificationMethod || "Phân loại phân tích của đề tài")}
    </div>
  </div>`;
}

function managementPopup(kind, d) {
  let rows = `<tr><td>Loại</td><td><b>${escapeHtml(d.type)}</b></td></tr><tr><td>Năm</td><td>${escapeHtml(d.year)}</td></tr>`;
  if (kind === "works") rows += `<tr><td>Trạng thái</td><td><b>${escapeHtml(d.status)}</b></td></tr><tr><td>Địa bàn</td><td>${escapeHtml(d.locality)}</td></tr>`;
  if (kind === "residential") rows += `<tr><td>Hộ dân</td><td><b>${escapeHtml(d.households ?? "Chưa công bố")}</b></td></tr><tr><td>Nhà sập</td><td>${escapeHtml(d.housesCollapsed ?? "Chưa công bố")}</td></tr><tr><td>Nhà di dời</td><td>${escapeHtml(d.housesRelocated ?? "Chưa công bố")}</td></tr>`;
  return `<div class="map-popup management-popup"><div class="popup-head"><b>${escapeHtml(d.id)}</b><span class="management-tag">${escapeHtml(managementStyle[kind].label)}</span></div><div class="popup-location">${escapeHtml(d.name)}</div><table>${rows}</table><div class="popup-note"><b>Nguồn:</b> ${escapeHtml(d.source)}<br><a href="${escapeHtml(d.sourceUrl)}" target="_blank" rel="noopener">Mở nguồn chính thống</a><br><b>Ghi chú:</b> ${escapeHtml(d.note)}<br><b>Tọa độ nguồn:</b> ${escapeHtml(d.coordinateStatus)}<br><b>Vị trí biểu diễn:</b> ${escapeHtml(d.displayCoordinateType || "Chưa có")}</div></div>`;
}

async function loadSatLoData() {
  const response = await fetch("/api/satlo-data", { headers: { "Accept": "application/json" } });
  if (!response.ok) throw new Error("Không thể đọc dữ liệu sạt lở");
  const data = await response.json();
  return { data, source: response.headers.get("X-WebGIS-Data-Source") || "unknown" };
}

async function loadManagementData() {
  const response = await fetch("/api/management", { headers: { "Accept": "application/json" } });
  if (!response.ok) throw new Error("Không thể đọc dữ liệu quản lý");
  const data = await response.json();
  return { data, source: response.headers.get("X-WebGIS-Data-Source") || "unknown" };
}

window.WebGIS = {
  map, layers, street, satellite, riverHau, riskColor, managementStyle, managementIcon, displayCoordinates, getDisplayCoordinate,
  managementPopup, AN_GIANG_CENTER, AN_GIANG_BOUNDS, loadSatLoData, loadManagementData, loadRiverHauLayer, popupHTML
};
