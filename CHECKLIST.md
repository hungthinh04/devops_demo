# ✅ DEPLOYMENT CHECKLIST

Checklist đầy đủ để đảm bảo deployment thành công.

---

## 📋 PHASE 1: CHUẨN BỊ

### Code & Repository
- [ ] Code đã hoàn thiện và test local
- [ ] Đã tạo `.gitignore` đúng
- [ ] Đã tạo repository trên GitHub
- [ ] Đã push code lên GitHub
- [ ] Đã test build local: `npm run build`
- [ ] Đã kiểm tra thư mục build output (dist/ hoặc build/)

### Domain & DNS
- [ ] Đã mua domain
- [ ] Đã có tài khoản domain provider
- [ ] Đã note domain provider (Namecheap, GoDaddy, etc.)

### Cloud Platform
- [ ] Đã chọn cloud provider (DigitalOcean, AWS, etc.)
- [ ] Đã tạo tài khoản cloud
- [ ] Đã tạo VPS/Instance
- [ ] Đã có IP address của server
- [ ] Đã test kết nối SSH: `ssh user@server-ip`

### Cloudflare
- [ ] Đã tạo tài khoản Cloudflare
- [ ] Đã chuẩn bị thời gian để setup (30-60 phút)

---

## 📋 PHASE 2: SETUP SERVER

### Initial Setup
- [ ] Đã SSH vào server thành công
- [ ] Đã chạy `sudo apt update && sudo apt upgrade`
- [ ] Đã cài đặt Nginx: `sudo apt install nginx -y`
- [ ] Đã cài đặt Git: `sudo apt install git -y`
- [ ] Đã cài đặt Node.js (nếu cần): `curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -`
- [ ] Đã cài đặt Certbot: `sudo apt install certbot python3-certbot-nginx -y`
- [ ] Đã khởi động Nginx: `sudo systemctl start nginx`
- [ ] Đã enable Nginx: `sudo systemctl enable nginx`
- [ ] Đã test Nginx hoạt động (truy cập IP trong browser)

### Clone Code
- [ ] Đã tạo thư mục: `/var/www/my-web-app`
- [ ] Đã set permissions: `sudo chown -R $USER:$USER /var/www/my-web-app`
- [ ] Đã clone code: `git clone https://github.com/username/repo.git .`
- [ ] Đã install dependencies: `npm install`
- [ ] Đã build production: `npm run build`
- [ ] Đã kiểm tra thư mục build tồn tại

### Nginx Configuration
- [ ] Đã copy `nginx.conf.example` sang `/etc/nginx/sites-available/my-web-app`
- [ ] Đã chỉnh sửa config (thay yourdomain.com, đường dẫn)
- [ ] Đã test config: `sudo nginx -t`
- [ ] Đã tạo symlink: `sudo ln -s /etc/nginx/sites-available/my-web-app /etc/nginx/sites-enabled/`
- [ ] Đã xóa default config (nếu cần): `sudo rm /etc/nginx/sites-enabled/default`
- [ ] Đã reload Nginx: `sudo systemctl reload nginx`
- [ ] Đã test HTTP: `curl http://localhost` hoặc truy cập IP

---

## 📋 PHASE 3: CLOUDFLARE SETUP

### Add Domain
- [ ] Đã đăng nhập Cloudflare
- [ ] Đã thêm domain vào Cloudflare
- [ ] Đã chọn plan (Free recommended)
- [ ] Đã review DNS records được scan

### Nameservers
- [ ] Đã copy 2 nameservers từ Cloudflare
- [ ] Đã vào domain provider
- [ ] Đã thay đổi nameservers sang Cloudflare
- [ ] Đã save changes
- [ ] Đã quay lại Cloudflare và click Continue
- [ ] Đã đợi nameservers propagate (5 phút - 24 giờ)
- [ ] Đã verify: `nslookup yourdomain.com` (thấy Cloudflare IPs)

### DNS Records
- [ ] Đã vào DNS tab trong Cloudflare
- [ ] Đã thêm A record cho `@` → Server IP (🟠 Proxied)
- [ ] Đã thêm A record cho `www` → Server IP (🟠 Proxied)
- [ ] Đã thêm các records khác (subdomains, email, etc.) nếu cần
- [ ] Đã verify DNS: `dig yourdomain.com`

### SSL/TLS
- [ ] Đã vào SSL/TLS tab
- [ ] Đã chọn encryption mode (Full hoặc Full strict)
- [ ] Đã bật "Always Use HTTPS"
- [ ] Nếu Full strict: Đã tạo SSL certificate trên server

### Server SSL (cho Full strict)
- [ ] Đã SSH vào server
- [ ] Đã chạy: `sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com`
- [ ] Đã chọn option 2 (redirect HTTP to HTTPS)
- [ ] Đã verify certificate: `sudo certbot certificates`
- [ ] Đã test HTTPS trên server: `curl https://localhost`

### Cloudflare Optimizations
- [ ] Đã vào Speed tab
- [ ] Đã bật Auto Minify (JS, CSS, HTML)
- [ ] Đã bật Brotli
- [ ] Đã vào Network tab
- [ ] Đã bật HTTP/3 (with QUIC)
- [ ] Đã vào Caching tab
- [ ] Đã cấu hình Caching Level (Standard)
- [ ] Đã cấu hình Browser Cache TTL

### Security
- [ ] Đã vào Security tab
- [ ] Đã set Security Level (Medium recommended)
- [ ] Đã bật Browser Integrity Check
- [ ] Đã cấu hình Challenge Passage

---

## 📋 PHASE 4: TESTING

### Domain & DNS
- [ ] DNS đã propagate: `nslookup yourdomain.com`
- [ ] Domain trỏ đúng IP: `dig yourdomain.com`
- [ ] Website load được qua HTTP: `http://yourdomain.com`
- [ ] Website load được qua HTTPS: `https://yourdomain.com`
- [ ] HTTP redirect sang HTTPS tự động

### SSL Certificate
- [ ] SSL certificate hiển thị đúng (khóa xanh)
- [ ] Không có SSL warnings
- [ ] Certificate issuer: Let's Encrypt hoặc Cloudflare

### Website Functionality
- [ ] Homepage load được
- [ ] Tất cả routes hoạt động (SPA routing)
- [ ] Images/assets load đúng
- [ ] CSS/JS load đúng
- [ ] Không có lỗi trong browser console (F12)
- [ ] Không có lỗi trong Network tab
- [ ] Forms hoạt động (nếu có)
- [ ] API calls hoạt động (nếu có)

### Performance
- [ ] Website load nhanh (< 3 giây)
- [ ] CDN đang hoạt động (check Cloudflare analytics)
- [ ] Gzip/Brotli compression hoạt động
- [ ] Static assets được cache

### Mobile
- [ ] Website responsive trên mobile
- [ ] Test trên iOS Safari
- [ ] Test trên Android Chrome

---

## 📋 PHASE 5: DEPLOYMENT WORKFLOW

### Setup Git Hooks (Optional)
- [ ] Đã tạo GitHub Actions workflow (nếu cần CI/CD)
- [ ] Đã test automated deployment

### Deploy Script
- [ ] Đã chỉnh sửa `deploy.sh` với thông tin server
- [ ] Đã test deploy script
- [ ] Đã thêm Cloudflare API token (nếu cần auto-purge)

### Documentation
- [ ] Đã document deployment process cho team
- [ ] Đã tạo runbook cho troubleshooting
- [ ] Đã note các credentials quan trọng (và lưu an toàn)

---

## 📋 PHASE 6: MONITORING & MAINTENANCE

### Monitoring Setup
- [ ] Đã setup uptime monitoring (UptimeRobot, Pingdom, etc.)
- [ ] Đã setup error tracking (Sentry, etc.) nếu cần
- [ ] Đã setup analytics (Google Analytics, etc.)

### Backups
- [ ] Đã setup backup strategy cho code
- [ ] Đã setup backup cho database (nếu có)
- [ ] Đã test restore process

### Maintenance
- [ ] Đã schedule update server: `sudo apt update && sudo apt upgrade`
- [ ] Đã setup auto-renew SSL: `sudo certbot renew --dry-run`
- [ ] Đã note các commands thường dùng

---

## 🆘 TROUBLESHOOTING CHECKLIST

### Nếu website không load:
- [ ] Kiểm tra Nginx status: `sudo systemctl status nginx`
- [ ] Kiểm tra Nginx logs: `sudo tail -f /var/log/nginx/error.log`
- [ ] Kiểm tra Nginx config: `sudo nginx -t`
- [ ] Kiểm tra firewall: `sudo ufw status`
- [ ] Kiểm tra DNS: `nslookup yourdomain.com`
- [ ] Kiểm tra Cloudflare proxy status (🟠 Proxied)

### Nếu SSL lỗi:
- [ ] Kiểm tra SSL mode trên Cloudflare (Full/Full strict)
- [ ] Kiểm tra certificate trên server: `sudo certbot certificates`
- [ ] Renew certificate: `sudo certbot renew`
- [ ] Kiểm tra Nginx SSL config

### Nếu 502 Bad Gateway:
- [ ] Kiểm tra application có chạy không
- [ ] Kiểm tra port trong Nginx config
- [ ] Kiểm tra permissions: `ls -la /var/www/my-web-app`

### Nếu 403 Forbidden:
- [ ] Kiểm tra permissions: `sudo chown -R www-data:www-data /var/www/my-web-app`
- [ ] Kiểm tra file permissions: `sudo chmod -R 755 /var/www/my-web-app`
- [ ] Kiểm tra index file tồn tại

---

## 📝 NOTES

### Server Information
```
Server IP: _______________
SSH User: _______________
Domain: _______________
Cloudflare Zone ID: _______________
```

### Important Commands
```bash
# SSH vào server
ssh user@server-ip

# Reload Nginx
sudo systemctl reload nginx

# Check Nginx status
sudo systemctl status nginx

# View logs
sudo tail -f /var/log/nginx/error.log

# Test Nginx config
sudo nginx -t

# Deploy code mới
./deploy.sh
```

---

## ✅ HOÀN THÀNH

Khi tất cả items đã được check:

- [ ] ✅ Website đã live và hoạt động
- [ ] ✅ HTTPS đã được bật
- [ ] ✅ Cloudflare CDN đang hoạt động
- [ ] ✅ Team đã biết cách deploy code mới
- [ ] ✅ Monitoring đã được setup

**🎉 Deployment hoàn thành!**

---

*Cập nhật checklist này sau mỗi deployment để đảm bảo không bỏ sót bước nào.*

