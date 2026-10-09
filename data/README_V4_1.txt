BỘ DỮ LIỆU WEBGIS SẠT LỞ SÔNG HẬU – AN GIANG
Phiên bản: V4.1 – phân loại mức độ sạt lở

MỤC ĐÍCH
- Giữ nguyên cấu trúc quan hệ V4 và bổ sung phân loại mức độ sạt lở cho lớp sự kiện.
- Phân loại phục vụ hiển thị/lọc trên WebGIS và phân tích trong báo cáo.
- Không thay thế mức cảnh báo chính thức của cơ quan nhà nước.

KẾT QUẢ PHÂN LOẠI
- Bình thường: 1
- Nguy hiểm: 7
- Đặc biệt nguy hiểm: 7
- Chưa phân loại: 2

CÁCH HIỂU CÁC TRƯỜNG
Trong satlo_incident.csv:
- severity_level: mức độ phân loại của đề tài.
- severity_score: điểm quy đổi theo thang 0–100 đối với các sự kiện đủ dữ liệu.
- classification_basis: nhóm bằng chứng dùng để phân loại.
- classification_confidence: độ tin cậy dữ liệu (Cao/Trung bình/Thấp).
- classification_evidence: tóm tắt bằng chứng hiện có.
- source_warning_level: mức cảnh báo do nguồn công bố; hiện để “Chưa phân loại” nếu nguồn sự kiện không công bố trực tiếp.
- classification_method: ghi rõ đây là phân loại phân tích, không hồi tố cấp cảnh báo.

NGUYÊN TẮC
1. Không ép số lượng các nhóm phải bằng nhau.
2. Không coi “không có thông tin” là “không có thiệt hại”.
3. Sự kiện chỉ có thông tin khảo sát nhưng thiếu chiều dài/thiệt hại được để “Chưa phân loại”.
4. Không gán mức “Bình thường/Nguy hiểm/Đặc biệt nguy hiểm” của chương trình quan trắc An Giang cho một sự kiện cá biệt nếu nguồn không công bố trực tiếp.
5. Các mức “Bình thường/Nguy hiểm/Đặc biệt nguy hiểm” trong bộ dữ liệu này là phân loại phân tích của đề tài. Đây không phải là “cấp độ rủi ro thiên tai” theo Quyết định 18/2021/QĐ-TTg.
6. Có thể dùng source_warning_level và warning_segment để hiển thị lớp cảnh báo chính thức riêng.

CƠ SỞ THAM KHẢO
- An Giang có chương trình quan trắc/cảnh báo sạt lở sử dụng các mức “bình thường”, “nguy hiểm”, “đặc biệt nguy hiểm”; số lượng từng mức thay đổi theo từng đợt quan trắc.
- Nguồn địa phương năm 2022 ghi nhận 56 đoạn cảnh báo: 5 đặc biệt nguy hiểm, 37 nguy hiểm, 14 bình thường.
- Nguồn năm 2025 tiếp tục yêu cầu rà soát các khu vực cảnh báo đặc biệt nguy hiểm và tổ chức di dời khi cần.
- Vì không có một bảng ngưỡng pháp lý duy nhất quy định điểm 0–100 cho từng vụ sạt lở, thang điểm trong bộ dữ liệu được dùng như phương pháp phân tích của đề tài và phải được mô tả rõ trong báo cáo.

CÁC FILE BỔ SUNG
- severity_level.csv: danh mục 4 trạng thái dùng cho bộ lọc WebGIS.
- severity_indicator.csv: bộ chỉ báo/điểm tham khảo để giải thích phương pháp.
- severity_assessment.csv: bảng giải trình phân loại từng sự kiện.

LƯU Ý KIỂM CHỨNG
Bộ V4.1 giữ nguyên các trường nguồn của V4. Một số URL/sự kiện trong V4 trước đó chưa được tái kiểm chứng toàn bộ trong lần chỉnh sửa này; vì vậy V4.1 không nên được gọi là “đã xác minh tuyệt đối toàn bộ nguồn”. Đặc biệt, SLH-2026-001 vẫn giữ trạng thái “Cần đối chiếu”.

CẤU TRÚC QUAN HỆ
Các PK/FK của V4 được giữ nguyên. Ba bảng severity mới là lớp phục vụ phân loại và giải trình; không phá vỡ các quan hệ hiện có.


CẬP NHẬT WEBGIS FINAL21 - DATA3 (22/09/2026)
- Tích hợp bộ dữ liệu Data3 vào WebGIS Final21.
- Bổ sung latitude và longitude cho 17 sự kiện trong satlo_incident.csv.
- Các bảng dữ liệu khác được giữ theo Data3; lớp hình học Sông Hậu của Final21 được giữ nguyên.
