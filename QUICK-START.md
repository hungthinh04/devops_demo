# ⚡ QUICK START GUIDE - Deploy Web trong 30 phút

Hướng dẫn nhanh để deploy website của bạn lên production.

## 📋 YÊU CẦU

- [ ] Domain name (đã mua)
- [ ] VPS/Cloud server (DigitalOcean, AWS, etc.)
- [ ] Code đã push lên GitHub
- [ ] Tài khoản Cloudflare (free)

---

## 🚀 CÁC BƯỚC NHANH

### 1️⃣ Setup Server (5 phút)

```bash
# SSH vào server
ssh root@your-server-ip

# Cài đặt Nginx
sudo apt update && sudo apt install nginx -y

# Cài đặt Certbot (cho SSL)
sudo apt install certbot python3-certbot-nginx -y

# Khởi động Nginx
sudo systemctl start nginx && sudo systemctl enable nginx
```

### 2️⃣ Clone & Build (5 phút)

```bash
# Tạo thư mục
cd /var/www
sudo mkdir my-web-app
sudo chown $USER:$USER my-web-app
cd my-web-app

# Clone từ GitHub
git clone https://github.com/username/my-web-app.git .

# Build (nếu Node.js app)
npm install
npm run build
```

### 3️⃣ Cấu hình Nginx (5 phút)

```bash
# Copy config mẫu
sudo cp nginx.conf.example /etc/nginx/sites-available/my-web-app

# Chỉnh sửa (thay yourdomain.com)
sudo nano /etc/nginx/sites-available/my-web-app

# Kích hoạt site
sudo ln -s /etc/nginx/sites-available/my-web-app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 4️⃣ Setup Cloudflare (10 phút)

1. Đăng nhập [cloudflare.com](https://www.cloudflare.com)
2. Add site: `yourdomain.com`
3. Chọn plan **Free**
4. Copy 2 nameservers
5. Vào domain provider → Update nameservers
6. Đợi 5-30 phút
7. Vào DNS tab → Add A records:
   - `@` → `YOUR_SERVER_IP` (🟠 Proxied)
   - `www` → `YOUR_SERVER_IP` (🟠 Proxied)
8. SSL/TLS → Chọn **Full**
9. Always Use HTTPS → **ON**

### 5️⃣ Tạo SSL Certificate (5 phút)

```bash
# SSH vào server
ssh root@your-server-ip

# Tạo certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Chọn option 2 (redirect HTTP to HTTPS)
```

### 6️⃣ Kiểm tra (1 phút)

Truy cập: `https://yourdomain.com`

✅ Nếu thấy website → **THÀNH CÔNG!**

---

## 🔄 DEPLOY CODE MỚI

```bash
# Trên local
npm run build
rsync -avz --delete dist/ user@server-ip:/var/www/my-web-app/dist/

# Hoặc dùng script
chmod +x deploy.sh
./deploy.sh
```

---

## 🆘 GẶP VẤN ĐỀ?

### Website không load?
```bash
# Kiểm tra Nginx
sudo systemctl status nginx
sudo nginx -t

# Kiểm tra logs
sudo tail -f /var/log/nginx/error.log
```

### DNS chưa trỏ đúng?
```bash
# Kiểm tra DNS
nslookup yourdomain.com
dig yourdomain.com
```

### SSL lỗi?
- Kiểm tra SSL mode trên Cloudflare: **Full** hoặc **Full (strict)**
- Kiểm tra certificate trên server: `sudo certbot certificates`

---

## 📚 TÀI LIỆU CHI TIẾT

Xem file `README.md` để có hướng dẫn chi tiết đầy đủ!

---

**Chúc bạn deploy thành công! 🎉**

