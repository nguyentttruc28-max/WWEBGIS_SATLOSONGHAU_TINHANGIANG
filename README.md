# WEBGIS – QUẢN LÝ SẠT LỞ SÔNG HẬU ĐOẠN QUA TỈNH AN GIANG

## 1. Mục tiêu phiên bản V6.1

Phiên bản này **giữ giao diện và khung mã nguồn của WebGIS phiên bản trước**, đồng thời **thay thế phần dữ liệu cũ bằng bộ dữ liệu `WebGIS_SatLo_SongHau_AnGiang_V4_1_PhanLoaiMucDo`** mà người dùng cung cấp.

Luồng chính vẫn giữ theo cấu trúc của tài liệu hướng dẫn:

```text
Người dùng → EJS/JavaScript → Express API → PostgreSQL/PostGIS → JSON → Leaflet/Chart.js
```

Các thành phần `app.js`, `views/`, `public/`, `.env`, `package.json`, `package-lock.json`, `README.md` và `vercel.json` vẫn được giữ theo khung cũ. Chỉ những câu lệnh truy vấn, cấu trúc database và nội dung giao diện liên quan trực tiếp đến dữ liệu được cập nhật.

## 2. Dữ liệu mới được sử dụng

Bộ dữ liệu V4.1 gồm 16 tệp CSV, trong đó V4.1 bổ sung ba bảng phục vụ phân loại mức độ:

```text
satlo_incident.csv
measurement.csv
warning_level.csv
warning_segment.csv
incident_warning_link.csv
affected_residential.csv
affected_road.csv
management_work.csv
management_sources.csv
reference_source.csv
city_locality.csv
river_source.csv
legal_basis.csv
severity_level.csv
severity_indicator.csv
severity_assessment.csv
```

WebGIS không còn sử dụng các bảng dữ liệu cũ như `sample_measurement`, `measurement_year`, `hau_region` hoặc `satlo_segments` làm nguồn chính.

## 3. Nguyên tắc dữ liệu V4.1 được giữ nguyên

- `satlo_incident` là **các sự kiện sạt lở thực tế**.
- `warning_segment` là **các đoạn bờ sông được cảnh báo theo từng năm**.
- `incident_warning_link` chỉ liên kết hai loại dữ liệu khi bộ dữ liệu có căn cứ tương ứng.
- Không tự tạo tọa độ.
- Không tự gán mức cảnh báo cho sự kiện không có liên kết cảnh báo.
- Không coi giá trị `NULL` là không xảy ra.
- Giữ địa danh lịch sử trong dữ liệu.
- `REF012` được giữ trạng thái cần đối chiếu PDF gốc trước khi dùng làm bằng chứng cuối cùng.

## 4. Phân loại mức độ trên WebGIS

Bộ V4.1 bổ sung `severity_level.csv`, `severity_indicator.csv` và `severity_assessment.csv`. Kết quả phân loại 17 sự kiện là:

- Đặc biệt nguy hiểm: 7
- Nguy hiểm: 7
- Bình thường: 1
- Chưa phân loại: 2

Trên WebGIS, bốn mức này chính là bốn nhóm điểm để lọc. Nếu không chọn mức nào, hệ thống hiển thị tất cả sự kiện phù hợp với các điều kiện tìm kiếm/năm.

Điểm `severity_score` chỉ dùng cho phân tích của đề tài. Nó không được hiểu là cấp độ rủi ro thiên tai pháp lý.

### 4.1. Cảnh báo chính thức

Bảng `warning_level` của bộ dữ liệu có bốn giá trị:

- Bình thường
- Nguy hiểm
- Đặc biệt nguy hiểm
- Chưa phân loại

WebGIS giữ riêng mức cảnh báo nguồn và mức phân loại của đề tài. Không dùng `warning_level` để thay thế `severity_level`.

```text
satlo_incident
      ↓
incident_warning_link
      ↓
warning_segment
      ↓
warning_level
```

Nếu nguồn sự kiện không công bố mức cảnh báo tương ứng, trường `source_warning_level` giữ **Chưa phân loại**; trường `severity_level` vẫn dùng kết quả phân loại V4.1 nếu đã có. Màu sắc trên bản đồ chỉ là quy ước trực quan của WebGIS.

## 5. Tọa độ và hiển thị bản đồ

Bộ V4.1 hiện chỉ cung cấp tọa độ nguồn cho một sự kiện (`SLH-2024-002`). Các sự kiện còn lại không có tọa độ nguồn trong bộ dữ liệu. Để đáp ứng chức năng lọc–bản đồ, WebGIS sử dụng thêm `data/display_coordinates.json` với tọa độ đại diện theo địa bàn. Tọa độ nguồn không bị sửa và popup phân biệt rõ “tọa độ theo dữ liệu nguồn” với “tọa độ đại diện”. Các bảng quản lý V4.1 cũng được biểu diễn bằng tọa độ đại diện khi chưa có GPS.

Vì vậy phiên bản V6.1 xử lý như sau:

- Bản ghi vẫn được lưu đầy đủ trong PostgreSQL và API.
- Bản ghi có tọa độ được hiển thị trên bản đồ.
- Bản ghi chưa có tọa độ **không bị đặt vào một vị trí giả**.
- Giao diện hiển thị số sự kiện chưa có tọa độ để người dùng nhận biết giới hạn dữ liệu.

Đây là lựa chọn có chủ ý để không biến tọa độ suy diễn thành dữ liệu chính thức.

## 6. Cấu trúc PostgreSQL/PostGIS

```text
db/
├── init.sql      # bật PostGIS
├── schema.sql    # tạo cấu trúc các bảng V4.1
└── seed.sql      # nạp dữ liệu V4.1
```

Có thể sử dụng PostgreSQL/PostGIS trực tiếp trên máy. Khi đặt `AUTO_INIT_DB=true`, server sẽ tự chạy `init.sql`, `schema.sql` và `seed.sql` nếu bảng `satlo_incident` chưa tồn tại.

## 7. Chạy WebGIS

```bash
npm install
npm start
```

Sau đó mở:

```text
http://localhost:3000
```

Tài khoản demo:

```text
Username: demo123
Password: demo123
```

Để kết nối PostgreSQL, tạo `.env` từ `.env.example` và đặt `DATABASE_URL`.

## 8. Giao diện

Giao diện được giữ theo phiên bản WebGIS trước:

- Trang đăng nhập.
- Thanh tiêu đề và menu.
- Bản đồ Leaflet.
- Panel bộ lọc bên trái.
- Tìm kiếm.
- Lọc theo năm.
- Lọc theo mức độ phân loại.
- Chuyển đổi bản đồ nền.
- Nhóm lớp quản lý: công trình, khu dân cư và giao thông.
- Trang Tổng quan.
- Trang Dữ liệu.
- Trang Hướng dẫn.

Các dòng chữ giao diện tiếp tục sử dụng Arial theo phiên bản trước.

## 9. GitHub

Project không chứa `.git` cũ. Có thể kết nối với repository mới bằng:

```bash
git init
git remote add origin LINK_REPOSITORY
git add .
git commit -m "Cap nhat WebGIS voi du lieu V4.1"
git branch -M main
git push -u origin main
```

## 10. Lưu ý về dữ liệu

Bộ dữ liệu V4.1 là cơ sở dữ liệu mà phiên bản WebGIS này sử dụng. Những trường chưa được nguồn công bố sẽ được giữ ở trạng thái chưa có dữ liệu; WebGIS không tự bổ sung số liệu thuộc tính để làm đầy bảng; riêng lớp hiển thị có thể dùng tọa độ đại diện theo địa bàn được tách riêng và ghi rõ nguồn/ý nghĩa.

Đặc biệt, trước khi sử dụng bản đồ như sản phẩm GIS hiện trường chính thức, cần bổ sung/kiểm chứng tọa độ không gian cho các sự kiện và đối tượng quản lý nếu nguồn chính thức hoặc khảo sát thực địa cung cấp.

## Lớp Sông Hậu tham chiếu
WebGIS V6.7 thay lớp `song_hau_reference` và hình học dựng từ vài điểm trước đó bằng `public/river/song_hau_detailed.shp` cùng `.shx`, `.dbf`, `.prj`, `.cpg` và `song_hau_detailed.geojson`. Lớp mới dùng hình học chi tiết từ OpenStreetMap được WaterwayMap công bố, gồm Sông Hậu và các nhánh chính Sông Châu Đốc, Sông Bình Di, Sông Vàm Nao và Rạch Ông Chưởng. Hệ tọa độ WGS 84 / EPSG:4326. Đây là lớp đường thủy tham chiếu phục vụ trực quan hóa WebGIS, không phải đường bờ sông hay dữ liệu đo đạc hiện trường.


## Bản tích hợp Final21 + Data3
- Giữ nguyên giao diện, bộ lọc, lớp quản lý và lớp Sông Hậu của Final21.
- Tích hợp các bảng CSV từ Data3.
- `satlo_incident.csv` có thêm `latitude`, `longitude` cho 17 điểm sạt lở.
- PostgreSQL schema/seed đã được cập nhật để đọc hai trường tọa độ mới khi kết nối cơ sở dữ liệu.
- Khi chưa có PostgreSQL, fallback JSON cũng sử dụng tọa độ mới.

## Bản sửa giao diện và tương tác nhóm quản lý (v2.2.0)

- Bỏ khung **Cơ sở pháp lý** ở góc dưới bên phải bản đồ.
- Sửa cơ chế xác định tọa độ cho các nhóm quản lý: dân cư/giao thông ưu tiên mã sự kiện liên kết; công trình được đối chiếu theo địa bàn khi chưa có `incident_code`.
- Bổ sung điểm tham chiếu cho Quốc Thái để công trình tại khu vực này có thể hiển thị.
- Checkbox **Công trình**, **Dân cư**, **Giao thông** tiếp tục điều khiển trực tiếp các `LayerGroup` tương ứng.
