# PostgreSQL/PostGIS của WebGIS

- `schema.sql`: tạo cấu trúc 6 bảng.
- `seed.sql`: dữ liệu 15 điểm/đoạn sạt lở và nguồn tham khảo.
- `init.sql`: bản khởi tạo tổng hợp, có thể dùng cho database mới.

## Docker

Từ thư mục gốc project:

```bash
docker compose up -d
```

Docker sẽ tạo PostgreSQL + PostGIS và tự chạy `init.sql` khi volume database được tạo lần đầu.

## PostgreSQL/Neon

Đặt `DATABASE_URL` trong `.env`. Có thể đặt `AUTO_INIT_DB=true` để server tự tạo bảng + dữ liệu nếu bảng `satlo_incident` chưa tồn tại.
