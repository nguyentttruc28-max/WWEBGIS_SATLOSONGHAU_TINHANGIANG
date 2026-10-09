-- WebGIS Sông Hậu An Giang V4.1 – seed dữ liệu quan hệ + phân loại mức độ.
-- Dữ liệu severity_level/severity_assessment/severity_indicator được lấy trực tiếp từ bộ V4.1.
TRUNCATE TABLE severity_assessment, severity_indicator, severity_level, incident_warning_link, warning_segment, warning_level, affected_road, affected_residential, management_work, management_sources, legal_basis, satlo_incident, measurement, city_locality, river_source, reference_source CASCADE;
INSERT INTO reference_source (id_reference,reference_name,year,source_type,provider,reference_url) VALUES
('REF018','Sự kiện sạt lở QL91, Bình Mỹ ngày 27/5/2020',2020,'Cơ quan trung ương','Tổng cục PCTT/Bộ NN&PTNT','https://phongchongthientai.mard.gov.vn/Pages/pho-tuong-ban-ban-chi-dao-trung-uong-ve-phong-chong-thien-tai-tran-quang-hoai-kiem-tra-cong-tac--.aspx'),
('REF001','Sạt lở nghiêm trọng bờ Tây sông Hậu, di dời khẩn 3 nhà dân',2021,'Báo chí nhà nước/TTXVN','VietnamPlus','https://www.vietnamplus.vn/an-giang-sat-lo-nghiem-trong-bo-tay-song-hau-di-doi-khan-3-nha-dan-post694741.vnp'),
('REF019','Quan trắc và cảnh báo sạt lở đất bờ sông đợt I năm 2021',2021,'Cơ quan nhà nước','Sở TN&MT An Giang','https://media.angiang.gov.vn/Phutan-Portal/File/2021/08/20/8.2021.BC_sat%20lo%20dot_I_2021-da%20chuyen%20doi%20%281%29.pdf'),
('REF002','Công bố tình huống khẩn cấp thiên tai sạt lở bờ Tây sông Hậu',2022,'Báo chí nhà nước/TTXVN','VietnamPlus','https://www.vietnamplus.vn/an-giang-cong-bo-tinh-huong-khan-cap-thien-tai-sat-lo-bo-tay-song-hau-post803500.vnp'),
('REF003','Báo cáo sạt lở đất bờ sông, kênh, rạch 21-24/5/2023',2023,'Cơ quan nhà nước','BCH PCTT An Giang','https://media.angiang.gov.vn/thu%20tuc%20hanh%20chanh/KQ-TTHC/2023/26%20HTMT%20cv%20-%2035%20-%20sat%20lo%20cm-cp%20ngay%2021-24-05-2023-a%20khanh.signed.pdf'),
('REF004','Phú Hữu gia cố sạt lở bờ đông sông Hậu',2023,'Cơ quan nhà nước','UBND huyện An Phú/UBND xã Phú Hữu','https://anphu.angiang.gov.vn/index.php/phu-huu-gia-co-sat-lo-doan-bo-dong-song-hau-thuoc-ap-phu-thanh'),
('REF020','Kết quả quan trắc cảnh báo sạt lở đợt I/2023',2023,'Cơ quan nhà nước','Sở TN&MT An Giang','https://sonongnghiep.angiang.gov.vn/wps/portal/'),
('REF005','Báo cáo 77/BC-VPTT ngày 20/9/2024',2024,'Cơ quan nhà nước','Văn phòng Thường trực PCTT An Giang','https://app.angiang.gov.vn/sites/default/files/angiang/2024-09/HTMT%20cv%20-%2077%20-%20bc%20tinh%20hinh%20ung%20pho%20bao%20so%204%20ngay%20tu%2017-9%20den%2020-9-2024.signed.pdf'),
('REF006','Báo cáo 81/BC-VPTT ngày 24/9/2024',2024,'Cơ quan nhà nước','Văn phòng Thường trực PCTT An Giang','https://app.angiang.gov.vn/sites/default/files/angiang/2024-09/HTMT%20cv%20-%2081%20-%20bc%20sat%20lo%20pt%20ngay%2023-9.signed.pdf'),
('REF007','Báo cáo 86/BC-VPTT ngày 30/9/2024',2024,'Cơ quan nhà nước','Văn phòng Thường trực PCTT An Giang','https://app.angiang.gov.vn/sites/default/files/angiang/2024-10/HTMT%20cv%20-%2086%20-%20bc%20sat%20lo%20pt%20ngay%2020240930.signed.pdf'),
('REF021','Kết quả quan trắc cảnh báo sạt lở năm 2024',2024,'Cơ quan nhà nước/báo chí nhà nước','Sở TN&MT An Giang/TTXVN','https://baotintuc.vn/an-giang-56-doan-song-duoc-quan-trac-chat-che-canh-bao-nguy-co-sat-lo-n20240510064332156.htm'),
('REF008','Sạt lở bờ sông Hậu dài 100m, ăn sâu 25m',2025,'Báo chí nhà nước/TTXVN','VietnamPlus/TTXVN','https://www.vietnamplus.vn/an-giang-tiep-tuc-xay-ra-sat-lo-bo-song-nghiem-trong-tai-xa-my-hoa-hung-post1074257.vnp'),
('REF009','Sạt lở nghiêm trọng tại tổ 3, ấp Mỹ Thuận',2025,'Cơ quan nhà nước','UBND xã Mỹ Hòa Hưng','https://myhoahung.angiang.gov.vn/tin-tuc-su-kien?page=41'),
('REF010','Sạt lở ảnh hưởng 13 căn nhà xã Phú Hữu',2025,'Cơ quan nhà nước','UBND xã Phú Hữu','https://phuhuu.angiang.gov.vn/xay-ra-vu-sat-lo-lam-anh-huong-den-13-can-nha-cua-nguoi-dan-xa-bien-gioi-phu-huu'),
('REF011','UBND tỉnh khảo sát sạt lở tại xã Phú Hữu',2025,'Cơ quan nhà nước','UBND tỉnh/UBND xã Phú Hữu','https://phuhuu.angiang.gov.vn/doan-cong-tac-ubnd-tinh-giang-khao-sat-tinh-hinh-sat-lo-tai-xa-phu-huu'),
('REF022','Kết quả quan trắc cảnh báo sạt lở năm 2025',2025,'Báo chí nhà nước/TTXVN','TTXVN','https://baotintuc.vn/an-giang-co-56-doan-song-duoc-canh-bao-nguy-co-sat-lo-n20250602142137694.htm'),
('REF012','Báo cáo nhanh PCTT ngày 10/4/2026',2026,'Cơ quan trung ương','Cục Quản lý đê điều và PCTT/Bộ NN&MT','https://phongchongthientai.mard.gov.vn/Pages/bao-cao-nhanh-cong-tac-truc-ban-pctt-ngay-10-4-2026.aspx'),
('REF013','Sạt lở bờ sông Hậu ấp Phú Thành',2026,'Cơ quan nhà nước','UBND xã Phú Hữu','https://phuhuu.angiang.gov.vn/node/1252'),
('REF014','Sạt lở ấp Mỹ Khánh 1 ngày 25/8/2026',2026,'Cơ quan nhà nước','UBND xã Mỹ Hòa Hưng','https://myhoahung.angiang.gov.vn/my-hoa-hung-khan-truong-ho-tro-nguoi-dan-bi-anh-huong-do-sat-lo-bo-song'),
('REF015','Sạt lở tiếp tục tại ấp Mỹ Khánh 1 ngày 9/9/2026',2026,'Cơ quan nhà nước','UBND xã Mỹ Hòa Hưng','https://myhoahung.angiang.gov.vn/khan-truong-ung-pho-sat-lo-tiep-tuc-tai-ap-my-khanh-1'),
('REF023','Quyết định 01/2011/QĐ-TTg - Quy chế xử lý sạt lở bờ sông, bờ biển',2011,'Văn bản pháp luật','Thủ tướng Chính phủ','https://vanban.chinhphu.vn/default.aspx?docid=98533&pageid=27160'),
('REF024','Quyết định 18/2021/QĐ-TTg - cấp độ rủi ro thiên tai',2021,'Văn bản pháp luật','Thủ tướng Chính phủ','https://vanban.chinhphu.vn/'),
('REF025','Chỉ thị 17/2006/CT-UBND An Giang về cảnh báo, phòng chống sạt lở',2006,'Văn bản địa phương','UBND tỉnh An Giang','https://angiang.gov.vn/'),
('REF017','Thông cáo về dự án xử lý sạt lở khẩn cấp sông Hậu và kè chống sạt lở',2023,'Cơ quan nhà nước','UBND tỉnh An Giang','https://angiang.gov.vn/vi/thong-cao-bao-chi-ve-viec-thuc-hien-du-xu-ly-sat-lo-khan-cap-sat-lo-bo-song-hau-va-du-ke-chong-sat');

INSERT INTO river_source (id_river,river_name,province,data_role,status,note) VALUES
('RIVER001','Sông Hậu','An Giang','Đối tượng không gian của đề tài','Tham chiếu','Không tự dựng geometry');

INSERT INTO city_locality (id_city,commune,locality,district_historical,province,admin_period) VALUES
('CITY001','Bình Mỹ','Bình Tân','Châu Phú','An Giang','2020-2024'),
('CITY002','Quốc Thái','Quốc Khánh','An Phú','An Giang','2020-2024'),
('CITY003','Phú Hữu','Phú Thành','An Phú','An Giang','2020-2024'),
('CITY004','Hòa Lạc','Hòa Lộc và Hòa Hưng 1','Phú Tân','An Giang','2020-2024'),
('CITY005','Mỹ Hòa Hưng','Mỹ Thuận','Long Xuyên','An Giang','2020-2024'),
('CITY006','Vĩnh Thạnh Trung','Vĩnh Phú','Châu Phú','An Giang','2020-2024'),
('CITY007','Mỹ Hòa Hưng','Mỹ Khánh 1','Long Xuyên','An Giang','2020-2024');

INSERT INTO measurement (id_measurement,measurement_year,id_city,id_reference,record_type) VALUES
('SLH-2020-001',2020,'CITY001','REF018','EVENT'),
('SLH-2021-001',2021,'CITY002','REF001','EVENT'),
('SLH-2022-001',2022,'CITY002','REF002','EVENT'),
('SLH-2023-001',2023,'CITY001','REF003','EVENT'),
('SLH-2023-002',2023,'CITY003','REF004','EVENT'),
('SLH-2024-001',2024,'CITY003','REF005','EVENT'),
('SLH-2024-002',2024,'CITY004','REF006','EVENT'),
('SLH-2024-003',2024,'CITY004','REF007','EVENT'),
('SLH-2025-001',2025,'CITY005','REF008','EVENT'),
('SLH-2025-002',2025,'CITY005','REF009','EVENT'),
('SLH-2025-003',2025,'CITY003','REF010','EVENT'),
('SLH-2025-004',2025,'CITY003','REF011','EVENT'),
('SLH-2025-005',2025,'CITY003','REF011','EVENT'),
('SLH-2026-001',2026,'CITY006','REF012','EVENT'),
('SLH-2026-002',2026,'CITY003','REF013','EVENT'),
('SLH-2026-003',2026,'CITY007','REF014','EVENT'),
('SLH-2026-004',2026,'CITY007','REF015','EVENT');

INSERT INTO satlo_incident (incident_code,observed_date,id_city,commune,locality,district_historical,river_section,length_m,bank_inland_m,affected_households,latitude_reference,longitude_reference,coordinate_status,latitude,longitude,impact_summary,id_reference,verification_status,severity_level,severity_score,classification_basis,classification_confidence,classification_evidence,source_warning_level,classification_method,geom) VALUES
('SLH-2020-001','2020-05-27','CITY001','Bình Mỹ','Bình Tân','Châu Phú','Sông Hậu - QL91','40.0',NULL,NULL,'10.551389','105.275833','Tọa độ tham chiếu tương đối','10.551389','105.275833','Ảnh hưởng khoảng 1/3 mặt đường QL91','REF018','Đã xác minh','Nguy hiểm','55.0','Quy mô + ảnh hưởng hạ tầng','Trung bình','40 m; mất khoảng 1/3 mặt đường QL91','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.275833,10.551389),4326)),
('SLH-2021-001','2021-02-10','CITY002','Quốc Thái','Quốc Khánh','An Phú','Bờ Tây sông Hậu','50.0','60','3.0','10.916540','105.082950','Tọa độ tham chiếu tương đối','10.916540','105.082950','Di dời khẩn cấp 3 nhà dân','REF001','Đã xác minh','Đặc biệt nguy hiểm','85.0','Quy mô + mức độ ảnh hưởng dân cư + di dời','Cao','50 m; ăn sâu 60 m; 3 hộ; di dời khẩn cấp','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.082950,10.916540),4326)),
('SLH-2022-001','2022-05-18','CITY002','Quốc Thái','Quốc Khánh','An Phú','Bờ Tây sông Hậu','30.0','4','2.0','10.915900','105.082500','Tọa độ tham chiếu tương đối','10.915900','105.082500','Ảnh hưởng trực tiếp 2 nhà','REF002','Đã xác minh','Nguy hiểm','55.0','Quy mô + ảnh hưởng nhà dân','Cao','30 m; ăn sâu 4 m; ảnh hưởng trực tiếp 2 nhà','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.082500,10.915900),4326)),
('SLH-2023-001','2023-05-21','CITY001','Hòa Bình','An Thái','Chợ Mới','Bờ Tả sông Hậu','70.0','10',NULL,'10.362137','105.463193','Tọa độ tham chiếu tương đối','10.362137','105.463193','Ảnh hưởng xí nghiệp chế biến lương thực','REF003','Đã xác minh','Đặc biệt nguy hiểm','75.0','Quy mô + ảnh hưởng công trình','Trung bình','70 m; ăn sâu 10 m; ảnh hưởng cơ sở sản xuất','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.463193,10.362137),4326)),
('SLH-2023-002','2023-08-01','CITY003','Phú Hữu','Phú Thành','An Phú','Bờ Đông sông Hậu','100.0',NULL,NULL,'10.918100','105.092200','Tọa độ tham chiếu tương đối','10.918100','105.092200','Chuỗi 3 đoạn từ đầu 8 đến đầu 10/2023','REF004','Đã xác minh','Đặc biệt nguy hiểm','72.0','Quy mô + hạ tầng','Trung bình','100 m; có nguy cơ/ảnh hưởng gần đường giao thông','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.092200,10.918100),4326)),
('SLH-2024-001','2024-09-19','CITY003','Phú Hữu','Phú Thành','An Phú','Bờ Đông sông Hậu','40.0','3','1.0','10.917300','105.091500','Tọa độ tham chiếu tương đối','10.917300','105.091500','Cách nhà khoảng 5m, đường khoảng 20m','REF005','Đã xác minh','Nguy hiểm','48.0','Quy mô + dân cư + hạ tầng','Cao','40 m; ăn sâu 3 m; 1 hộ; đường cách khoảng 20 m','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.091500,10.917300),4326)),
('SLH-2024-002','2024-09-23','CITY004','Hòa Lạc','Hòa Lộc và Hòa Hưng 1','Phú Tân','Bờ Đông sông Hậu',NULL,NULL,'7.0','10.693557','105.196626','Theo báo cáo chính thức','10.693557','105.196626','Ảnh hưởng 7 hộ, không thiệt hại người','REF006','Đã xác minh','Nguy hiểm','55.0','Số hộ + nguồn chính thức','Cao','7 hộ bị ảnh hưởng; có tọa độ theo báo cáo chính thức','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.196626,10.693557),4326)),
('SLH-2024-003','2024-09-29','CITY004','Hòa Lạc','Hòa An','Phú Tân','Bờ Đông sông Hậu','9.0','3','1.0','10.674616','105.209292','Tọa độ tham chiếu tương đối','10.674616','105.209292','Ảnh hưởng 1 căn nhà','REF007','Đã xác minh','Bình thường','25.0','Quy mô + ảnh hưởng hạn chế','Cao','9 m; ăn sâu 3 m; 1 nhà bị ảnh hưởng','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.209292,10.674616),4326)),
('SLH-2025-001','2025-09-04','CITY005','Mỹ Hòa Hưng','Mỹ Thuận','Long Xuyên','Sông Hậu - đầu cồn','100.0','25','2.0','10.437222','105.417500','Tọa độ tham chiếu tương đối','10.437222','105.417500','2 nhà sụp hoàn toàn','REF008','Đã xác minh','Đặc biệt nguy hiểm','78.0','Quy mô + mức độ thiệt hại','Cao','100 m; ăn sâu 25 m; 2 nhà sụp hoàn toàn','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.417500,10.437222),4326)),
('SLH-2025-002','2025-10-31','CITY005','Mỹ Hòa Hưng','Mỹ Thuận','Long Xuyên','Sông Hậu','150.0','20','12.0','10.436500','105.418200','Tọa độ tham chiếu tương đối','10.436500','105.418200','Đường sụp hoàn toàn; 12 hộ/44 nhân khẩu','REF009','Đã xác minh','Đặc biệt nguy hiểm','95.0','Quy mô + dân cư + hạ tầng','Cao','150 m; ăn sâu 20 m; 12 hộ/44 người; đường sụp hoàn toàn','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.418200,10.436500),4326)),
('SLH-2025-003','2025-11-17','CITY003','Phú Hữu','Vĩnh Phước','An Phú','Bờ Đông sông Hậu','150.0','5-10','13.0','10.851389','105.078889','Tọa độ tham chiếu tương đối','10.851389','105.078889','13 nhà; 5 sập, 8 di dời','REF010','Đã xác minh','Đặc biệt nguy hiểm','98.0','Quy mô + thiệt hại + di dời','Cao','150 m; 13 nhà; 5 nhà sập, 8 hộ di dời','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.078889,10.851389),4326)),
('SLH-2025-004','2025-11-17','CITY003','Phú Hữu','Vĩnh Phước - Đình thần Vĩnh Lộc','An Phú','Bờ Đông sông Hậu','20.0','4',NULL,'10.850900','105.079400','Tọa độ tham chiếu tương đối','10.850900','105.079400','Một điểm được đoàn UBND tỉnh khảo sát','REF011','Đã xác minh','Chưa phân loại',NULL,'Thiếu dữ liệu đầu vào','Thấp','Chỉ ghi nhận điểm được đoàn khảo sát; chưa có đủ thông tin định lượng/thiệt hại','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.079400,10.850900),4326)),
('SLH-2025-005','2025-11-17','CITY003','Phú Hữu','Vĩnh Phước - sau Văn phòng Ban Nhân dân ấp','An Phú','Bờ Đông sông Hậu','25.0','~5',NULL,'10.851800','105.078500','Tọa độ tham chiếu tương đối','10.851800','105.078500','Một điểm được đoàn UBND tỉnh khảo sát','REF011','Đã xác minh','Chưa phân loại',NULL,'Thiếu dữ liệu đầu vào','Thấp','Chỉ ghi nhận điểm được đoàn khảo sát; chưa có đủ thông tin định lượng/thiệt hại','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.078500,10.851800),4326)),
('SLH-2026-001','2026-04-10','CITY006','Vĩnh Thạnh Trung','Vĩnh Phú','Châu Phú','Sông Hậu','50.0',NULL,NULL,'10.594444','105.215278','Tọa độ tham chiếu tương đối','10.594444','105.215278','Sụp bờ kè và 2 băng tải; cần đối chiếu năm trong PDF gốc','REF012','Cần đối chiếu','Nguy hiểm','60.0','Ảnh hưởng hạ tầng + dữ liệu cần kiểm chứng','Thấp','50 m; sụp bờ kè và 2 băng tải; nguồn trong bộ dữ liệu đang cần đối chiếu','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.215278,10.594444),4326)),
('SLH-2026-002','2026-08-12','CITY003','Phú Hữu','Phú Thành','An Phú','Bờ Đông sông Hậu','60.0','3-7','6.0','10.918500','105.092500','Tọa độ tham chiếu tương đối','10.918500','105.092500','6 hộ có nguy cơ; gần đường giao thông','REF013','Đã xác minh','Nguy hiểm','65.0','Quy mô + dân cư + hạ tầng','Cao','60 m; ăn sâu 3–7 m; 6 hộ có nguy cơ; gần đường','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.092500,10.918500),4326)),
('SLH-2026-003','2026-08-25','CITY007','Mỹ Hòa Hưng','Mỹ Khánh 1','Long Xuyên','Sông Hậu - đầu cồn','50.0','7','8.0','10.419900','105.416100','Tọa độ tham chiếu tương đối','10.419900','105.416100','8 hộ/21 nhân khẩu','REF014','Đã xác minh','Nguy hiểm','68.0','Quy mô + dân cư + hạ tầng','Cao','50 m; ăn sâu 7 m; 8 hộ/21 người; ảnh hưởng trực tiếp đường','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.416100,10.419900),4326)),
('SLH-2026-004','2026-09-09','CITY007','Mỹ Hòa Hưng','Mỹ Khánh 1','Long Xuyên','Sông Hậu - đầu cồn','50.0','5','4.0','10.420500','105.416800','Tọa độ tham chiếu tương đối','10.420500','105.416800','4 hộ/16 nhân khẩu; 2 hộ tháo dỡ nhà','REF015','Đã xác minh','Đặc biệt nguy hiểm','80.0','Dân cư + tháo dỡ nhà + hạ tầng','Cao','50 m; ăn sâu 5 m; 4 hộ/16 người; 2 hộ tháo dỡ nhà; ảnh hưởng đường','Chưa phân loại','Phân loại phân tích của đề tài; không hồi tố cấp cảnh báo của nguồn',ST_SetSRID(ST_MakePoint(105.416800,10.420500),4326));

INSERT INTO warning_level (id_warning_level,warning_level_name,definition,id_reference) VALUES
('WARN01','Bình thường','Mức cảnh báo sạt lở bờ sông của chương trình quan trắc An Giang','REF019'),
('WARN02','Nguy hiểm','Mức cảnh báo sạt lở bờ sông của chương trình quan trắc An Giang','REF019'),
('WARN03','Đặc biệt nguy hiểm','Mức cảnh báo sạt lở bờ sông của chương trình quan trắc An Giang','REF019'),
('WARN99','Chưa phân loại','Nguồn sự kiện không công bố mức cảnh báo','REF023');

INSERT INTO warning_segment (id_warning_segment,warning_year,segment_name,commune,district_historical,id_warning_level,length_m,id_reference) VALUES
('WS-2021-01',2021,'Sông Hậu qua Châu Phong','Châu Phong','Tân Châu','WARN03',NULL,'REF019'),
('WS-2021-02',2021,'Sông Hậu qua Bình Mỹ','Bình Mỹ','Châu Phú','WARN03',NULL,'REF019'),
('WS-2023-01',2023,'Sông Hậu qua Châu Phong','Châu Phong','Tân Châu','WARN03',6900,'REF020'),
('WS-2023-02',2023,'Sông Hậu qua Bình Mỹ','Bình Mỹ','Châu Phú','WARN03',1900,'REF020'),
('WS-2023-03',2023,'Sông Hậu qua Mỹ Hòa Hưng','Mỹ Hòa Hưng','Long Xuyên','WARN03',3300,'REF020'),
('WS-2024-01',2024,'Sông Hậu qua Châu Phong','Châu Phong','Tân Châu','WARN03',NULL,'REF021'),
('WS-2024-02',2024,'Sông Hậu qua Bình Mỹ','Bình Mỹ','Châu Phú','WARN03',NULL,'REF021'),
('WS-2024-03',2024,'Sông Hậu qua Mỹ Hòa Hưng','Mỹ Hòa Hưng','Long Xuyên','WARN03',NULL,'REF021'),
('WS-2025-01',2025,'Sông Hậu qua Châu Phong','Châu Phong','Tân Châu','WARN03',NULL,'REF022'),
('WS-2025-02',2025,'Sông Hậu qua Bình Mỹ','Bình Mỹ','Châu Phú','WARN03',NULL,'REF022'),
('WS-2025-03',2025,'Sông Hậu qua Mỹ Hòa Hưng','Mỹ Hòa Hưng','Long Xuyên','WARN03',NULL,'REF022');

INSERT INTO incident_warning_link (id_link,incident_code,id_warning_segment,relation_type,note,id_reference) VALUES
('LINK001','SLH-2020-001','WS-2024-02','Liên hệ không gian, không hồi tố','Khu vực Bình Mỹ thuộc đoạn cảnh báo; không gán mức 2024 cho vụ 2020','REF018'),
('LINK002','SLH-2026-004','WS-2025-03','Liên hệ không gian, không hồi tố','Khu vực Mỹ Hòa Hưng; không gán mức 2025 cho vụ 2026','REF015');

INSERT INTO affected_residential (id_residential,incident_code,households,persons,impact_status,id_reference) VALUES
('RES001','SLH-2021-001',3,NULL,'Di dời khẩn cấp','REF001'),
('RES002','SLH-2022-001',2,NULL,'Ảnh hưởng trực tiếp','REF002'),
('RES003','SLH-2024-001',1,NULL,'Có khả năng ảnh hưởng','REF005'),
('RES004','SLH-2024-002',7,NULL,'Ảnh hưởng','REF006'),
('RES005','SLH-2024-003',1,NULL,'Ảnh hưởng','REF007'),
('RES006','SLH-2025-001',2,NULL,'Sụp hoàn toàn','REF008'),
('RES007','SLH-2025-002',12,44,'Ảnh hưởng trực tiếp','REF009'),
('RES008','SLH-2025-003',13,NULL,'5 sập; 8 di dời','REF010'),
('RES009','SLH-2026-002',6,NULL,'Có nguy cơ ảnh hưởng','REF013'),
('RES010','SLH-2026-003',8,21,'Ảnh hưởng trực tiếp','REF014'),
('RES011','SLH-2026-004',4,16,'Ảnh hưởng trực tiếp; 2 hộ tháo dỡ','REF015');

INSERT INTO affected_road (id_road,incident_code,road_type,impact_detail,id_reference) VALUES
('ROAD001','SLH-2020-001','Quốc lộ 91','Mất khoảng 1/3 mặt đường','REF018'),
('ROAD002','SLH-2023-002','Đường giao thông nông thôn','Nguy cơ/ảnh hưởng gần tuyến đường','REF004'),
('ROAD003','SLH-2024-001','Đường giao thông nông thôn','Cách khoảng 20m','REF005'),
('ROAD004','SLH-2025-002','Đường giao thông','Tuyến đường sụp hoàn toàn','REF009'),
('ROAD005','SLH-2026-002','Đường giao thông nông thôn','Gần vị trí sạt lở','REF013'),
('ROAD006','SLH-2026-003','Đường giao thông đầu cồn','Ảnh hưởng trực tiếp','REF014'),
('ROAD007','SLH-2026-004','Đường giao thông đầu cồn','Ảnh hưởng trực tiếp','REF015');

INSERT INTO management_work (id_work,name,work_type,status,locality,district_historical,id_reference) VALUES
('WORK001','Kè chống sạt lở bờ Tây sông Hậu đoạn Quốc Thái','Kè chống sạt lở','Dự án/ứng phó','Quốc Thái','An Phú','REF002'),
('WORK002','Xử lý sạt lở khẩn cấp sông Hậu Vĩnh Thạnh Trung - Bình Mỹ','Xử lý khẩn cấp','Dự án','Châu Phú','Châu Phú','REF017'),
('WORK003','Kè chống sạt lở sông Hậu Châu Phong','Kè chống sạt lở','Dự án','Châu Phong','Tân Châu','REF017');

INSERT INTO management_sources (id_management_source,name,group_name,year,id_reference) VALUES
('MS001','Kè chống sạt lở bờ Tây sông Hậu Quốc Thái','Công trình chống sạt lở',2022,'REF002'),
('MS002','Xử lý sạt lở khẩn cấp Vĩnh Thạnh Trung - Bình Mỹ','Xử lý khẩn cấp',2023,'REF017'),
('MS003','Kè chống sạt lở sông Hậu Châu Phong','Công trình chống sạt lở',2023,'REF017');

INSERT INTO legal_basis (id_legal,document_name,topic,application_note,id_reference) VALUES
('LEGAL001','Quyết định 01/2011/QĐ-TTg','Quy chế xử lý sạt lở bờ sông, bờ biển','Cơ sở pháp lý trực tiếp','REF023'),
('LEGAL002','Quyết định 18/2021/QĐ-TTg','Dự báo, cảnh báo, cấp độ rủi ro thiên tai','Không tự gán cấp độ pháp lý cho từng vụ nếu nguồn không công bố','REF024'),
('LEGAL003','Chỉ thị 17/2006/CT-UBND An Giang','Cảnh báo, phòng chống và khắc phục sạt lở','Cơ sở chương trình quan trắc địa phương','REF025');
