# 📘 HƯỚNG DẪN DEPLOY WEB HOÀN CHỈNH

## 🔄 LUỒNG DEPLOY WEB

```
Code (GitHub)
   ↓
Build (npm build)
   ↓
Server (VPS / Cloud / Platform)
   ↓
Nginx (reverse proxy)
   ↓
Domain + DNS
   ↓
Cloudflare (SSL, CDN, bảo mật)
   ↓
User truy cập
```

---

## 📋 MỤC LỤC

1. [Bước 1: Chuẩn bị Code trên GitHub](#bước-1-chuẩn-bị-code-trên-github)
2. [Bước 2: Build Application](#bước-2-build-application)
3. [Bước 3: Setup Server (VPS/Cloud)](#bước-3-setup-server-vpscloud)
4. [Bước 4: Cấu hình Nginx](#bước-4-cấu-hình-nginx)
5. [Bước 5: Cấu hình Domain & DNS](#bước-5-cấu-hình-domain--dns)
6. [Bước 6: Cấu hình Cloudflare](#bước-6-cấu-hình-cloudflare)
7. [Bước 7: Kiểm tra và Deploy](#bước-7-kiểm-tra-và-deploy)

---

## 🚀 BƯỚC 1: CHUẨN BỊ CODE TRÊN GITHUB

### 1.1. Tạo Repository trên GitHub

1. Truy cập [https://github.com](https://github.com)
2. Đăng nhập vào tài khoản GitHub
3. Click **"New repository"** (nút màu xanh)
4. Điền thông tin:
   - **Repository name**: `my-web-app`
   - **Description**: Mô tả dự án
   - **Visibility**: Public hoặc Private
   - ✅ **Initialize with README** (nếu chưa có code)
5. Click **"Create repository"**

### 1.2. Push Code lên GitHub

```bash
# Nếu đã có project local
cd your-project-folder

# Khởi tạo git (nếu chưa có)
git init

# Thêm remote repository
git remote add origin https://github.com/username/my-web-app.git

# Thêm tất cả files
git add .

# Commit
git commit -m "Initial commit"

# Push lên GitHub
git branch -M main
git push -u origin main
```

### 1.3. Cấu hình .gitignore

Tạo file `.gitignore` để loại trừ các file không cần thiết:

```gitignore
# Dependencies
node_modules/
package-lock.json
yarn.lock

# Build outputs
dist/
build/
.next/
out/

# Environment variables
.env
.env.local
.env.production

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
```

---

## 🔨 BƯỚC 2: BUILD APPLICATION

### 2.1. Build React/Vue/Next.js

```bash
# React
npm run build
# Output: dist/ hoặc build/

# Vue.js
npm run build
# Output: dist/

# Next.js
npm run build
npm run export  # Nếu dùng static export
# Output: out/
```

### 2.2. Build Script tự động

Tạo file `build.sh`:

```bash
#!/bin/bash
echo "🚀 Bắt đầu build..."

# Install dependencies
npm install

# Build production
npm run build

echo "✅ Build thành công!"
echo "📁 Output: dist/"
```

Chạy:

```bash
chmod +x build.sh
./build.sh
```

---

## 🖥️ BƯỚC 3: SETUP SERVER (VPS/CLOUD)

### 3.1. Chọn nhà cung cấp Cloud

#### **Option A: VPS (DigitalOcean, Linode, Vultr)**

- Truy cập: [https://www.digitalocean.com](https://www.digitalocean.com)
- Tạo account và đăng nhập
- Click **"Create"** → **"Droplets"**
- Chọn:
  - **Image**: Ubuntu 22.04 LTS
  - **Plan**: $6/month (1GB RAM) đủ cho web nhỏ
  - **Region**: Singapore (gần Việt Nam)
  - **Authentication**: SSH keys (khuyên dùng) hoặc Password
- Click **"Create Droplet"**

#### **Option B: AWS EC2**

- Truy cập: [https://aws.amazon.com](https://aws.amazon.com)
- Đăng nhập AWS Console
- Vào **EC2** → **Launch Instance**
- Chọn **Ubuntu Server 22.04 LTS**
- Chọn **t2.micro** (Free tier) hoặc **t3.small**
- Configure security group: Mở ports 22, 80, 443
- Launch và tải key pair (.pem file)

#### **Option C: Google Cloud Platform**

- Truy cập: [https://cloud.google.com](https://cloud.google.com)
- Tạo project mới
- Vào **Compute Engine** → **VM instances**
- Click **"Create Instance"**
- Chọn **Ubuntu 22.04 LTS**
- Click **"Create"**

### 3.2. Kết nối SSH đến Server

```bash
# Với SSH Key
ssh -i path/to/key.pem root@your-server-ip

# Với Password
ssh root@your-server-ip

# Lần đầu tiên sẽ hỏi, gõ: yes
```

### 3.3. Cài đặt môi trường trên Server

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Cài đặt Nginx
sudo apt install nginx -y

# Cài đặt Node.js (nếu cần build trên server)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Cài đặt Git
sudo apt install git -y

# Cài đặt Certbot (cho SSL tự động)
sudo apt install certbot python3-certbot-nginx -y

# Khởi động Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Kiểm tra Nginx đã chạy
sudo systemctl status nginx
```

### 3.4. Clone Code từ GitHub

```bash
# Tạo thư mục cho project
cd /var/www
sudo mkdir my-web-app
sudo chown $USER:$USER my-web-app

# Clone repository
git clone https://github.com/username/my-web-app.git .

# Hoặc clone vào thư mục riêng
cd /var/www
sudo git clone https://github.com/username/my-web-app.git
sudo chown -R $USER:$USER my-web-app
```

---

## ⚙️ BƯỚC 4: CẤU HÌNH NGINX

### 4.1. Tạo Nginx Config File

```bash
sudo nano /etc/nginx/sites-available/my-web-app
```

Nội dung file config:

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    # Root directory chứa file build
    root /var/www/my-web-app/dist;
    index index.html index.htm;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # Logging
    access_log /var/log/nginx/my-web-app-access.log;
    error_log /var/log/nginx/my-web-app-error.log;

    # Main location
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

### 4.2. Kích hoạt Site

```bash
# Tạo symbolic link
sudo ln -s /etc/nginx/sites-available/my-web-app /etc/nginx/sites-enabled/

# Xóa default config (optional)
sudo rm /etc/nginx/sites-enabled/default

# Test cấu hình
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### 4.3. Nếu dùng Backend API (Node.js/Express)

Tạo config Nginx với reverse proxy:

```nginx
# Frontend
server {
    listen 80;
    server_name yourdomain.com;

    root /var/www/my-web-app/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API requests to backend
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 🌐 BƯỚC 5: CẤU HÌNH DOMAIN & DNS

### 5.1. Mua Domain

#### **Option A: Namecheap**

1. Truy cập: [https://www.namecheap.com](https://www.namecheap.com)
2. Search domain name
3. Add to cart và checkout
4. Hoàn tất thanh toán

#### **Option B: GoDaddy**

1. Truy cập: [https://www.godaddy.com](https://www.godaddy.com)
2. Tìm và mua domain

#### **Option C: Freenom (Free .tk, .ml, .ga)**

1. Truy cập: [https://www.freenom.com](https://www.freenom.com)
2. Đăng ký domain miễn phí

### 5.2. Cấu hình DNS

#### **Nếu dùng Cloudflare** (Khuyên dùng - xem Bước 6)

#### **Nếu KHÔNG dùng Cloudflare:**

1. Vào DNS Management của domain provider
2. Thêm các records:

```
Type    Name    Value           TTL
A       @       YOUR_SERVER_IP  3600
A       www     YOUR_SERVER_IP  3600
```

3. Lưu lại và đợi 5-30 phút để DNS propagate

### 5.3. Kiểm tra DNS

```bash
# Kiểm tra DNS đã trỏ đúng chưa
nslookup yourdomain.com
dig yourdomain.com
```

---

## ☁️ BƯỚC 6: CẤU HÌNH CLOUDFLARE

### 6.1. Tạo tài khoản Cloudflare

1. Truy cập: [https://www.cloudflare.com](https://www.cloudflare.com)
2. Click **"Sign Up"**
3. Đăng ký với email hoặc Google/GitHub
4. Xác nhận email

### 6.2. Thêm Domain vào Cloudflare

1. Sau khi đăng nhập, click **"Add a Site"**
2. Nhập domain name: `yourdomain.com`
3. Click **"Add site"**
4. Chọn plan: **Free** (đủ dùng)
5. Cloudflare sẽ quét DNS records hiện tại
6. Kiểm tra và click **"Continue"**

### 6.3. Cập nhật Nameservers

Cloudflare sẽ cung cấp 2 nameservers, ví dụ:

```
elena.ns.cloudflare.com
pat.ns.cloudflare.com
```

1. Vào domain provider (Namecheap, GoDaddy...)
2. Tìm **Nameservers** settings
3. Thay đổi từ default nameservers sang Cloudflare nameservers
4. Lưu lại
5. Quay lại Cloudflare, click **"Continue"**
6. Đợi 5-30 phút để nameservers propagate

### 6.4. Cấu hình DNS Records trên Cloudflare

1. Vào **DNS** tab trong Cloudflare dashboard
2. Thêm/Chỉnh sửa records:

```
Type    Name    Content           Proxy Status    TTL
A       @       YOUR_SERVER_IP    🟠 Proxied      Auto
A       www     YOUR_SERVER_IP    🟠 Proxied      Auto
```

**Lưu ý**: Bật **Proxy** (orange cloud) để sử dụng CDN và SSL của Cloudflare

### 6.5. Cấu hình SSL/TLS

1. Vào tab **SSL/TLS**
2. Chọn **Encryption mode**: **Full** hoặc **Full (strict)**
   - **Full**: SSL giữa Cloudflare và server (certificate có thể self-signed)
   - **Full (strict)**: Cần valid SSL certificate trên server

#### **Tạo SSL Certificate trên Server (cho Full strict):**

```bash
# Dùng Certbot để tạo Let's Encrypt certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Follow instructions:
# - Enter email
# - Agree terms
# - Choose redirect HTTP to HTTPS (option 2)
```

### 6.6. Cấu hình Nginx cho Cloudflare

Cập nhật Nginx config để chấp nhận requests từ Cloudflare:

```nginx
# Thêm vào đầu file nginx config
# Real IP từ Cloudflare
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 131.0.72.0/22;
real_ip_header CF-Connecting-IP;

server {
    listen 80;
    listen [::]:80;
    server_name yourdomain.com www.yourdomain.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    # SSL certificates (nếu dùng Full strict)
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    root /var/www/my-web-app/dist;
    index index.html;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### 6.7. Cấu hình Caching trên Cloudflare

1. Vào tab **Caching** → **Configuration**
2. **Caching Level**: Standard
3. **Browser Cache TTL**: Respect Existing Headers
4. **Purge Cache**: Nếu cần clear cache sau khi deploy

### 6.8. Bảo mật (Security Settings)

1. Vào tab **Security**
2. **Security Level**: Medium
3. **Challenge Passage**: 30 minutes
4. **Browser Integrity Check**: ON

### 6.9. Các tính năng khác

- **Speed** → **Auto Minify**: Bật JS, CSS, HTML
- **Speed** → **Brotli**: ON
- **Network** → **HTTP/3 (with QUIC)**: ON
- **Analytics** → Xem traffic và thống kê

---

## ✅ BƯỚC 7: KIỂM TRA VÀ DEPLOY

### 7.1. Build và Upload Code

```bash
# Trên local machine
npm run build

# Upload lên server
scp -r dist/* user@your-server-ip:/var/www/my-web-app/dist/

# Hoặc dùng rsync (tốt hơn)
rsync -avz --delete dist/ user@your-server-ip:/var/www/my-web-app/dist/
```

### 7.2. Script Deploy tự động

Tạo file `deploy.sh`:

```bash
#!/bin/bash

echo "🚀 Bắt đầu deploy..."

# Build
echo "📦 Building..."
npm run build

# Upload to server
echo "📤 Uploading..."
rsync -avz --delete dist/ user@your-server-ip:/var/www/my-web-app/dist/

# Reload Nginx
echo "🔄 Reloading Nginx..."
ssh user@your-server-ip "sudo systemctl reload nginx"

# Purge Cloudflare cache (nếu có API key)
echo "🧹 Purging Cloudflare cache..."
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'

echo "✅ Deploy thành công!"
```

### 7.3. Test Deployment

1. Truy cập: `https://yourdomain.com`
2. Kiểm tra:
   - ✅ Website load được
   - ✅ HTTPS hoạt động (khóa xanh)
   - ✅ Tất cả routes hoạt động
   - ✅ Images/assets load đúng
   - ✅ Console không có errors

### 7.4. Kiểm tra Performance

```bash
# Test tốc độ
curl -I https://yourdomain.com

# Test SSL
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com
```

---

## 🔄 QUY TRÌNH DEPLOY MỚI

Mỗi khi có code mới:

```bash
# 1. Commit và push lên GitHub
git add .
git commit -m "Update features"
git push origin main

# 2. SSH vào server
ssh user@your-server-ip

# 3. Pull code mới
cd /var/www/my-web-app
git pull origin main

# 4. Build (nếu build trên server)
npm install
npm run build

# 5. Reload Nginx
sudo systemctl reload nginx

# 6. Purge Cloudflare cache (nếu cần)
```

---

## 🛠️ TROUBLESHOOTING

### Lỗi 502 Bad Gateway

```bash
# Kiểm tra Nginx logs
sudo tail -f /var/log/nginx/error.log

# Kiểm tra Nginx status
sudo systemctl status nginx

# Test Nginx config
sudo nginx -t
```

### Lỗi 403 Forbidden

```bash
# Kiểm tra permissions
sudo chown -R www-data:www-data /var/www/my-web-app
sudo chmod -R 755 /var/www/my-web-app
```

### DNS không hoạt động

- Kiểm tra DNS records trên Cloudflare
- Đợi 24-48 giờ nếu mới thay đổi nameservers
- Dùng `dig` hoặc `nslookup` để check

### SSL Certificate lỗi

```bash
# Renew certificate
sudo certbot renew

# Hoặc tạo lại
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com --force-renewal
```

---

## 📚 TÀI LIỆU THAM KHẢO

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Cloudflare Documentation](https://developers.cloudflare.com/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [DigitalOcean Tutorials](https://www.digitalocean.com/community/tutorials)

---

## 🎯 TỔNG KẾT

Sau khi hoàn thành tất cả các bước:

1. ✅ Code đã được push lên GitHub
2. ✅ Server đã được setup và cấu hình
3. ✅ Nginx đã chạy và serve website
4. ✅ Domain đã trỏ về server
5. ✅ Cloudflare đã bật SSL, CDN và bảo mật
6. ✅ User có thể truy cập website qua HTTPS

**Website của bạn đã sẵn sàng! 🎉**
#   d e v o p s _ d e m o  
 