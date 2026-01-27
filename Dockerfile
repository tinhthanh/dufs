# === STAGE 1: BUILDER ===
# Sử dụng Rust trên nền Alpine linux để build cho nhẹ
FROM rust:1-alpine AS builder

# Cài đặt các thư viện cần thiết để biên dịch C/Rust
RUN apk add --no-cache musl-dev

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy toàn bộ source code hiện tại vào container
COPY . .

# Thực hiện build bản release (tối ưu hiệu năng)
RUN cargo build --release

# === STAGE 2: RUNNER ===
# Sử dụng Alpine Linux siêu nhẹ để chạy ứng dụng
FROM alpine:latest

# Cài đặt chứng chỉ SSL (cần thiết nếu app có gọi ra ngoài https)
RUN apk add --no-cache ca-certificates

# Copy file thực thi (binary) từ bước Builder sang bước Runner
COPY --from=builder /app/target/release/dufs /usr/local/bin/dufs

# Thiết lập thư mục làm việc cho data
WORKDIR /data

# Thiết lập lệnh chạy mặc định
ENTRYPOINT ["/usr/local/bin/dufs"]
