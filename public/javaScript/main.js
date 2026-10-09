// Bộ điều khiển bản đồ: bộ lọc mức độ và các nhóm quản lý phải đồng bộ trực tiếp với lớp đang hiển thị.

document.addEventListener("DOMContentLoaded", async () => {
  const {
    map, layers, street, satellite, riverHau, riskColor, managementIcon, managementPopup,
    AN_GIANG_CENTER, AN_GIANG_BOUNDS, loadSatLoData, loadManagementData, loadRiverHauLayer, getDisplayCoordinate
  } = window.WebGIS;

  const searchInput = document.getElementById("searchInput");
  const riskSearch = document.getElementById("riskSearch");
  const yearSlider = document.getElementById("yearSlider");
  const yearValue = document.getElementById("yearValue");
  const selectedList = document.getElementById("selectedList");
  const mapStatus = document.getElementById("mapStatus");
  const resultCount = document.getElementById("resultCount");
  const dataSourceNote = document.getElementById("dataSourceNote");

  let satLoData = [];
  let managementData = { works: [], residential: [], roads: [] };
  let dataSource = "unknown";
  let managementSource = "unknown";
  let selected = new Set(JSON.parse(localStorage.getItem("webgisSelected") || "[]"));

  function saveSelected() {
    localStorage.setItem("webgisSelected", JSON.stringify([...selected]));
  }

  function getSelectedRisks() {
    return [...document.querySelectorAll(".risk-filter:checked")].map(x => x.value);
  }

  function hasSourceCoordinate(d) {
    return Number.isFinite(Number(d.lat)) && Number.isFinite(Number(d.lng)) && Number(d.lat) !== 0 && Number(d.lng) !== 0;
  }

  function normaliseSourceCoordinate(d) {
    const lat = Number(d.lat);
    const lng = Number(d.lng);
    return {
      ...d,
      lat: Number.isFinite(lat) && lat !== 0 ? lat : null,
      lng: Number.isFinite(lng) && lng !== 0 ? lng : null
    };
  }

  function attachDisplayCoordinate(d) {
    const coord = getDisplayCoordinate(d);
    if (!coord) return { ...d, displayLat: null, displayLng: null, displayCoordinateType: "Chưa có tọa độ hiển thị" };
    return { ...d, displayLat: coord.lat, displayLng: coord.lng, displayCoordinateType: coord.type };
  }

  function separateOverlappingDisplayPoints(rows) {
    // Chỉ tách trực quan các điểm dùng tọa độ đại diện; tọa độ nguồn thật không bị dịch.
    const groups = new Map();
    rows.forEach(d => {
      if (!Number.isFinite(d.displayLat) || !Number.isFinite(d.displayLng)) return;
      if (d.displayCoordinateType === "Tọa độ theo dữ liệu nguồn") return;
      const key = `${d.displayLat.toFixed(6)}|${d.displayLng.toFixed(6)}`;
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key).push(d);
    });
    groups.forEach(group => {
      if (group.length < 2) return;
      const radius = 0.0020;
      group.forEach((d, i) => {
        const angle = (2 * Math.PI * i) / group.length;
        d.displayLat += radius * Math.sin(angle);
        d.displayLng += radius * Math.cos(angle);
        d.displayCoordinateType = "Tọa độ đại diện + lệch hiển thị để tránh chồng điểm";
      });
    });
  }

  function filteredData() {
    const q = searchInput.value.trim().toLowerCase();
    const risk = riskSearch.value;
    const year = Number(yearSlider.value);
    const risks = getSelectedRisks();

    return satLoData.filter(d => {
      const text = `${d.id} ${d.viTri} ${d.xa} ${d.huyen} ${d.locality} ${d.risk}`.toLowerCase();
      const riskMatch = risks.length === 0 || risks.includes(d.risk);
      return text.includes(q) && (!risk || d.risk === risk) && riskMatch && Number(d.year) <= year;
    });
  }

  function markerStyle(d) {
    const isSelected = selected.has(d.id);
    return {
      radius: isSelected ? 11 : 8,
      color: "#ffffff",
      weight: isSelected ? 3 : 2,
      fillColor: riskColor[d.risk] || "#e85aad",
      fillOpacity: 0.98,
      opacity: 1
    };
  }

  function createMarkers() {
    satLoData.filter(d => Number.isFinite(d.displayLat) && Number.isFinite(d.displayLng)).forEach(d => {
      const marker = L.circleMarker([d.displayLat, d.displayLng], markerStyle(d));
      const coordinateLabel = d.displayCoordinateType === "Tọa độ theo dữ liệu nguồn"
        ? "Tọa độ nguồn"
        : "Tọa độ đại diện";
      marker.bindTooltip(`${d.id} – ${d.risk} · ${coordinateLabel}`, {
        direction: "top",
        offset: [0, -6],
        opacity: 0.9
      });
      marker.bindPopup(window.WebGIS.popupHTML(d), { maxWidth: 390, autoPanPadding: [30, 30] });
      marker.on("click", () => {
        if (selected.has(d.id)) selected.delete(d.id);
        else selected.add(d.id);
        saveSelected();
        marker.setStyle(markerStyle(d));
        updateSelectedList();
      });
      d._marker = marker;
    });
  }

  function updateSelectedList() {
    selected = new Set([...selected].filter(id => satLoData.some(d => d.id === id)));
    saveSelected();
    const chosen = satLoData.filter(d => selected.has(d.id));

    if (!chosen.length) {
      selectedList.innerHTML = '<span class="side-note">Chưa chọn điểm. Nhấp vào một điểm trên bản đồ để xem thông tin.</span>';
      return;
    }

    selectedList.innerHTML = chosen.map(d => `
      <button class="selected-item" type="button" data-id="${d.id}">
        <span><b>${d.id}</b><small>${d.xa}</small></span>
        <em style="border-color:${riskColor[d.risk] || "#e85aad"};color:${riskColor[d.risk] || "#e85aad"}">${d.risk}</em>
      </button>
    `).join("");

    selectedList.querySelectorAll(".selected-item").forEach(btn => btn.addEventListener("click", () => {
      const d = satLoData.find(x => x.id === btn.dataset.id);
      if (!d || !d._marker || !Number.isFinite(d.displayLat) || !Number.isFinite(d.displayLng)) return;
      map.flyTo([d.displayLat, d.displayLng], 14, { duration: 0.45 });
      d._marker.openPopup();
    }));
  }

  function updateMarkers() {
    const data = filteredData();
    const mappedData = data.filter(d => Number.isFinite(d.displayLat) && Number.isFinite(d.displayLng));
    const sourceCoords = data.filter(hasSourceCoordinate).length;
    const representativeCoords = mappedData.length - sourceCoords;
    const visible = new Set(mappedData.map(d => d.id));

    satLoData.forEach(d => {
      if (!d._marker) return;
      const shouldShow = visible.has(d.id);
      if (shouldShow) {
        if (!layers.risk.hasLayer(d._marker)) d._marker.addTo(layers.risk);
      } else if (layers.risk.hasLayer(d._marker)) {
        layers.risk.removeLayer(d._marker);
      }
      d._marker.setStyle(markerStyle(d));
    });

    resultCount.textContent = data.length;
    mapStatus.textContent = `${data.length} sự kiện phù hợp · ${mappedData.length} điểm đang hiển thị` +
      (representativeCoords ? ` · ${representativeCoords} điểm dùng tọa độ đại diện theo địa bàn` : "");
    updateSelectedList();
  }

  function resolveManagementCoordinate(d) {
    // 1) Nếu nguồn quản lý cung cấp GPS thật, luôn ưu tiên GPS thật.
    const actual = getDisplayCoordinate(d);
    if (actual) return actual;

    // 2) Dân cư/giao thông có khóa liên kết incident_code trong V4.1.
    const incidentId = d.incidentCode || d.incident_code || d.name;
    const incident = satLoData.find(x => x.id === incidentId);
    if (incident && Number.isFinite(incident.displayLat) && Number.isFinite(incident.displayLng)) {
      return {
        lat: incident.displayLat,
        lng: incident.displayLng,
        type: incident.displayCoordinateType === "Tọa độ theo dữ liệu nguồn"
          ? "Tọa độ theo sự kiện liên kết"
          : "Tọa độ đại diện theo sự kiện liên kết"
      };
    }

    // 3) Công trình có thể chưa có incident_code. Khi đó tìm sự kiện cùng
    // địa bàn (xã/địa điểm/huyện) để biểu diễn đúng khu vực quản lý.
    const keys = [d.locality, d.commune, d.xa, d.district, d.district_historical]
      .map(v => String(v || '').trim().toLowerCase())
      .filter(Boolean);
    if (keys.length) {
      const matched = satLoData.find(x => {
        const candidates = [x.xa, x.locality, x.huyen, x.viTri]
          .map(v => String(v || '').trim().toLowerCase());
        return keys.some(k => candidates.includes(k) || candidates.some(c => c && (c.includes(k) || k.includes(c))));
      });
      if (matched && Number.isFinite(matched.displayLat) && Number.isFinite(matched.displayLng)) {
        return {
          lat: matched.displayLat,
          lng: matched.displayLng,
          type: matched.displayCoordinateType === "Tọa độ theo dữ liệu nguồn"
            ? "Tọa độ theo sự kiện cùng địa bàn"
            : "Tọa độ đại diện theo địa bàn"
        };
      }
    }

    return null;
  }

  function renderManagementLayer(kind) {
    const group = layers[kind];
    group.clearLayers();

    (managementData[kind] || []).forEach(d => {
      const coord = resolveManagementCoordinate(d);
      if (!coord) return;

      d.displayLat = coord.lat;
      d.displayLng = coord.lng;
      d.displayCoordinateType = coord.type;

      const marker = L.marker([coord.lat, coord.lng], {
        icon: managementIcon(kind),
        keyboard: true
      });
      marker.bindTooltip(d.name, { direction: "top", offset: [0, -22], opacity: 0.92 });
      marker.bindPopup(managementPopup(kind, d), { maxWidth: 390, autoPanPadding: [25, 25] });
      marker.addTo(group);
    });
  }

  function applyManagementVisibility() {
    ["works", "residential", "roads"].forEach(kind => {
      const checkbox = document.getElementById(`toggle${kind[0].toUpperCase()}${kind.slice(1)}`);
      if (checkbox?.checked) layers[kind].addTo(map);
      else map.removeLayer(layers[kind]);
    });
  }

  const toggleRiverHau = document.getElementById("toggleRiverHau");
  toggleRiverHau?.addEventListener("change", async () => {
    try {
      if (toggleRiverHau.checked) {
        await loadRiverHauLayer();
        riverHau.addTo(map);
      } else {
        map.removeLayer(riverHau);
      }
    } catch (err) {
      console.error(err);
      toggleRiverHau.checked = false;
      mapStatus.textContent = "Không tải được lớp Sông Hậu";
    }
  });

  document.getElementById("basemapSelect").addEventListener("change", e => {
    if (e.target.value === "street") {
      map.removeLayer(satellite);
      street.addTo(map);
    } else {
      map.removeLayer(street);
      satellite.addTo(map);
    }
    setTimeout(() => map.invalidateSize(), 80);
  });

  searchInput.addEventListener("input", updateMarkers);
  riskSearch.addEventListener("change", updateMarkers);
  document.querySelectorAll(".risk-filter").forEach(x => x.addEventListener("change", updateMarkers));

  // Bộ lọc nhóm quản lý phải điều khiển trực tiếp các layer tương ứng trên bản đồ.
  [
    ["toggleWorks", "works"],
    ["toggleResidential", "residential"],
    ["toggleRoads", "roads"]
  ].forEach(([id, kind]) => {
    const checkbox = document.getElementById(id);
    checkbox?.addEventListener("change", () => {
      applyManagementVisibility();
      setTimeout(() => map.invalidateSize(), 50);
    });
  });
  yearSlider.addEventListener("input", () => {
    yearValue.textContent = yearSlider.value;
    updateMarkers();
  });

  document.getElementById("fitBtn").addEventListener("click", () => {
    const data = filteredData().filter(d => Number.isFinite(d.displayLat) && Number.isFinite(d.displayLng));
    if (data.length) map.fitBounds(data.map(d => [d.displayLat, d.displayLng]), { padding: [35, 35], maxZoom: 13 });
    else map.fitBounds(AN_GIANG_BOUNDS, { padding: [20, 20] });
  });

  document.getElementById("locateBtn").addEventListener("click", () => map.flyTo(AN_GIANG_CENTER, 10, { duration: 0.5 }));

  document.getElementById("resetBtn").addEventListener("click", () => {
    searchInput.value = "";
    riskSearch.value = "";
    yearSlider.value = 2026;
    yearValue.textContent = "2026";
    document.querySelectorAll(".risk-filter").forEach(x => x.checked = false);
    document.querySelectorAll("#toggleWorks, #toggleResidential, #toggleRoads, #toggleRiverHau").forEach(x => x.checked = false);
    map.removeLayer(riverHau);
    selected.clear();
    saveSelected();
    street.addTo(map);
    map.removeLayer(satellite);
    renderManagementLayer("works");
    renderManagementLayer("residential");
    renderManagementLayer("roads");
    applyManagementVisibility();
    updateMarkers();
    map.fitBounds(AN_GIANG_BOUNDS, { padding: [20, 20] });
  });

  const modal = document.getElementById("accountModal");
  document.getElementById("demoAccountBtn").addEventListener("click", () => modal.classList.remove("hidden"));
  document.getElementById("closeModal").addEventListener("click", () => modal.classList.add("hidden"));
  modal.addEventListener("click", e => { if (e.target === modal) modal.classList.add("hidden"); });

  try {
    const [satloResult, managementResult] = await Promise.all([loadSatLoData(), loadManagementData()]);

    // Không dùng Number(null) => 0. Đây là lỗi khiến 16 bản ghi thiếu tọa độ bị đưa về [0,0].
    satLoData = satloResult.data.map(normaliseSourceCoordinate).map(attachDisplayCoordinate);
    separateOverlappingDisplayPoints(satLoData);

    const rawManagement = managementResult.data || { works: [], residential: [], roads: [] };
    managementData = {
      works: [...(rawManagement.works || [])],
      residential: [...(rawManagement.residential || [])],
      roads: [...(rawManagement.roads || [])]
    };
    managementData._allWorks = [...managementData.works];

    dataSource = satloResult.source;
    managementSource = managementResult.source;

    createMarkers();
    renderManagementLayer("works");
    renderManagementLayer("residential");
    renderManagementLayer("roads");
    applyManagementVisibility();
    updateMarkers();

    dataSourceNote.textContent = dataSource === "postgresql"
      ? `Sạt lở: PostgreSQL/PostGIS · Lớp quản lý: ${managementSource === "postgresql" ? "PostgreSQL/PostGIS" : "dữ liệu chính thống đi kèm project"}. Tọa độ đại diện chỉ dùng để trực quan hóa khi V4.1 chưa công bố GPS sự kiện.`
      : "PostgreSQL chưa kết nối: hệ thống dùng bộ dữ liệu V4.1 đi kèm project. Các bản ghi chưa có GPS được hiển thị tại tọa độ đại diện theo địa bàn để bộ lọc và bản đồ đồng bộ.";

    map.fitBounds(AN_GIANG_BOUNDS, { padding: [20, 20] });
  } catch (err) {
    console.error(err);
    mapStatus.textContent = "Không tải được dữ liệu";
    dataSourceNote.textContent = "Kiểm tra server và PostgreSQL.";
  }
});
