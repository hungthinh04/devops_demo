# ☁️ HƯỚNG DẪN CHI TIẾT CẤU HÌNH CLOUDFLARE

## 📋 MỤC LỤC

1. [Tạo tài khoản và thêm Domain](#1-tạo-tài-khoản-và-thêm-domain)
2. [Cấu hình DNS Records](#2-cấu-hình-dns-records)
3. [Cấu hình SSL/TLS](#3-cấu-hình-ssltls)
4. [Cấu hình Caching](#4-cấu-hình-caching)
5. [Cấu hình Security](#5-cấu-hình-security)
6. [Cấu hình Speed Optimizations](#6-cấu-hình-speed-optimizations)
7. [Cloudflare API Setup](#7-cloudflare-api-setup)

---

## 1. TẠO TÀI KHOẢN VÀ THÊM DOMAIN

### Bước 1.1: Đăng ký tài khoản

1. Truy cập: **https://www.cloudflare.com**
2. Click nút **"Sign Up"** ở góc trên bên phải
3. Điền thông tin:
   - Email address
   - Password (tối thiểu 8 ký tự)
4. Hoặc đăng nhập bằng:
   - Google Account
   - GitHub Account
   - Microsoft Account
5. Xác nhận email qua link trong inbox

### Bước 1.2: Thêm Domain vào Cloudflare

1. Sau khi đăng nhập, bạn sẽ thấy dashboard
2. Click nút **"Add a Site"** (màu xanh)
3. Nhập domain name (ví dụ: `yourdomain.com`)
   - **KHÔNG** cần `www.` hoặc `http://`
4. Click **"Add site"**

### Bước 1.3: Chọn Plan

Cloudflare sẽ hỏi bạn chọn plan:

- **Free** (Khuyên dùng cho bắt đầu)
  - ✅ SSL/TLS
  - ✅ CDN
  - ✅ DDoS protection
  - ✅ Basic analytics
  - ✅ Unlimited bandwidth

- **Pro** ($20/tháng)
  - Tất cả tính năng Free +
  - Image optimization
  - Advanced analytics
  - Page rules

- **Business/Enterprise**
  - Cho doanh nghiệp lớn

**→ Chọn "Free" và click "Continue"**

### Bước 1.4: Cloudflare quét DNS Records

1. Cloudflare sẽ tự động quét các DNS records hiện tại từ nameservers cũ
2. Đợi vài giây để quét xong
3. Bạn sẽ thấy danh sách các records:
   - A records
   - CNAME records
   - MX records (email)
   - TXT records

4. **Kiểm tra và chỉnh sửa nếu cần:**
   - Click vào record để edit
   - Đảm bảo **Proxy status** là **🟠 Proxied** (cho A và CNAME)
   - MX records phải là **DNS only** (⚪ Gray cloud)

5. Click **"Continue"**

### Bước 1.5: Cập nhật Nameservers

Cloudflare sẽ cung cấp 2 nameservers, ví dụ:
```
elena.ns.cloudflare.com
pat.ns.cloudflare.com
```

**⚠️ QUAN TRỌNG: Bạn phải thay đổi nameservers ở domain provider!**

#### Cách cập nhật Nameservers:

**Namecheap:**
1. Đăng nhập vào [Namecheap](https://www.namecheap.com)
2. Vào **Domain List** → Click **Manage** bên cạnh domain
3. Vào tab **Nameservers**
4. Chọn **Custom DNS**
5. Nhập 2 nameservers của Cloudflare
6. Click **Save**

**GoDaddy:**
1. Đăng nhập vào [GoDaddy](https://www.godaddy.com)
2. Vào **My Products** → Click **DNS** bên cạnh domain
3. Scroll xuống **Nameservers**
4. Click **Change**
5. Chọn **Custom**
6. Nhập 2 nameservers của Cloudflare
7. Click **Save**

**Domain khác:**
- Tìm phần **Nameservers** hoặc **DNS Management**
- Thay đổi từ default sang Cloudflare nameservers

#### Quay lại Cloudflare:

1. Sau khi đã cập nhật nameservers ở provider
2. Quay lại Cloudflare dashboard
3. Click **"Continue"**
4. Cloudflare sẽ kiểm tra nameservers
5. **Thời gian chờ:** 5 phút - 24 giờ (thường là 1-2 giờ)

---

## 2. CẤU HÌNH DNS RECORDS

### Bước 2.1: Vào DNS Settings

1. Trong Cloudflare dashboard, click vào domain của bạn
2. Click tab **DNS** ở menu bên trái
3. Bạn sẽ thấy danh sách DNS records

### Bước 2.2: Thêm/Chỉnh sửa A Records

**A Record cho root domain (@):**

1. Click **"Add record"**
2. Điền thông tin:
   - **Type**: `A`
   - **Name**: `@` (hoặc để trống)
   - **IPv4 address**: IP của server (ví dụ: `192.0.2.1`)
   - **Proxy status**: 🟠 **Proxied** (quan trọng!)
   - **TTL**: Auto
3. Click **"Save"**

**A Record cho www:**

1. Click **"Add record"**
2. Điền thông tin:
   - **Type**: `A`
   - **Name**: `www`
   - **IPv4 address**: IP của server (cùng IP như trên)
   - **Proxy status**: 🟠 **Proxied**
   - **TTL**: Auto
3. Click **"Save"**

### Bước 2.3: Các loại Records khác

**CNAME Record (nếu cần subdomain):**
- **Type**: `CNAME`
- **Name**: `api` (hoặc tên subdomain)
- **Target**: `yourdomain.com` hoặc domain khác
- **Proxy**: 🟠 Proxied hoặc ⚪ DNS only (tùy nhu cầu)

**MX Records (cho email):**
- **Type**: `MX`
- **Name**: `@`
- **Mail server**: `mail.yourdomain.com`
- **Priority**: `10`
- **Proxy**: ⚪ **DNS only** (phải tắt proxy!)

**TXT Records (cho verification, SPF, DKIM):**
- **Type**: `TXT`
- **Name**: `@`
- **Content**: Text content
- **Proxy**: ⚪ DNS only

### Bước 2.4: Kiểm tra DNS Propagation

Sau khi cấu hình xong:

```bash
# Kiểm tra DNS đã trỏ đúng chưa
nslookup yourdomain.com
dig yourdomain.com

# Nếu thấy Cloudflare IPs trong kết quả → thành công!
```

---

## 3. CẤU HÌNH SSL/TLS

### Bước 3.1: Vào SSL/TLS Settings

1. Click tab **SSL/TLS** trong Cloudflare dashboard
2. Bạn sẽ thấy các tùy chọn encryption mode

### Bước 3.2: Chọn Encryption Mode

**Các chế độ:**

1. **Off** (Không khuyên dùng)
   - Tắt SSL, chỉ dùng HTTP

2. **Flexible**
   - ✅ HTTPS giữa User ↔ Cloudflare
   - ❌ HTTP giữa Cloudflare ↔ Server
   - **Không khuyên dùng** (không an toàn)

3. **Full**
   - ✅ HTTPS giữa User ↔ Cloudflare
   - ✅ HTTPS giữa Cloudflare ↔ Server
   - Server có thể dùng self-signed certificate
   - **Khuyên dùng** cho bắt đầu

4. **Full (strict)** ⭐ (Khuyên dùng)
   - ✅ HTTPS giữa User ↔ Cloudflare
   - ✅ HTTPS giữa Cloudflare ↔ Server
   - Server PHẢI có valid SSL certificate (Let's Encrypt)
   - **An toàn nhất**

**→ Chọn "Full (strict)" nếu đã có SSL trên server, hoặc "Full" nếu chưa có**

### Bước 3.3: Tạo SSL Certificate trên Server (cho Full strict)

Nếu chọn **Full (strict)**, bạn cần SSL certificate trên server:

```bash
# SSH vào server
ssh user@your-server-ip

# Cài Certbot (nếu chưa có)
sudo apt update
sudo apt install certbot python3-certbot-nginx -y

# Tạo SSL certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Follow instructions:
# - Enter email address
# - Agree to terms
# - Choose redirect HTTP to HTTPS (option 2)
```

Certificate sẽ được lưu tại:
```
/etc/letsencrypt/live/yourdomain.com/fullchain.pem
/etc/letsencrypt/live/yourdomain.com/privkey.pem
```

### Bước 3.4: Cấu hình Nginx cho SSL

Xem file `nginx.conf.example` để biết cách cấu hình Nginx với SSL.

### Bước 3.5: Always Use HTTPS

1. Trong SSL/TLS settings, scroll xuống
2. Tìm **"Always Use HTTPS"**
3. Bật toggle này lên
4. Tất cả HTTP requests sẽ tự động redirect sang HTTPS

---

## 4. CẤU HÌNH CACHING

### Bước 4.1: Vào Caching Settings

1. Click tab **Caching** trong Cloudflare dashboard
2. Section **Configuration**

### Bước 4.2: Caching Level

- **Standard** (Mặc định) - Khuyên dùng
- **Basic** - Cache ít hơn
- **Simplified** - Cache nhiều hơn

**→ Chọn "Standard"**

### Bước 4.3: Browser Cache TTL

- **Respect Existing Headers** (Khuyên dùng)
  - Cloudflare sẽ tuân theo Cache-Control headers từ server
  
- **4 hours**
- **8 hours**
- **1 day**
- **1 week**
- **1 month**
- **1 year**

**→ Chọn "Respect Existing Headers"**

### Bước 4.4: Purge Cache

Khi bạn deploy code mới, cần purge cache:

**Cách 1: Purge Everything (trong dashboard)**
1. Scroll xuống **Purge Cache**
2. Click **"Purge Everything"**
3. Confirm

**Cách 2: Purge bằng URL**
1. Trong **Purge Cache**
2. Chọn **"Custom Purge"**
3. Nhập URLs cần purge (mỗi URL một dòng)
4. Click **"Purge"**

**Cách 3: Purge bằng API** (xem phần 7)

---

## 5. CẤU HÌNH SECURITY

### Bước 5.1: Security Level

1. Click tab **Security** → **Settings**
2. **Security Level:**
   - **Essentially Off** - Tắt tất cả
   - **Low** - Chặn ít
   - **Medium** (Mặc định) - Cân bằng
   - **High** - Chặn nhiều hơn
   - **I'm Under Attack!** - Chặn tối đa (dùng khi bị DDoS)

**→ Chọn "Medium"**

### Bước 5.2: Challenge Passage

Thời gian miễn challenge sau khi pass:
- **30 minutes** (Mặc định)
- **1 hour**
- **2 hours**
- **3 hours**

### Bước 5.3: Browser Integrity Check

- **ON** (Khuyên dùng) - Kiểm tra browser headers
- **OFF** - Tắt kiểm tra

### Bước 5.4: Privacy Pass Support

Bật để hỗ trợ Privacy Pass extension.

### Bước 5.5: WAF (Web Application Firewall)

**Chỉ có trong Pro plan trở lên:**
- Tự động chặn các attack patterns
- Custom rules

---

## 6. CẤU HÌNH SPEED OPTIMIZATIONS

### Bước 6.1: Auto Minify

1. Click tab **Speed** → **Optimization**
2. **Auto Minify:**
   - ✅ **JavaScript** - Minify JS files
   - ✅ **CSS** - Minify CSS files
   - ✅ **HTML** - Minify HTML files

**→ Bật cả 3**

### Bước 6.2: Brotli

1. Tìm **Brotli**
2. Bật toggle
3. Cloudflare sẽ compress responses bằng Brotli (tốt hơn Gzip)

### Bước 6.3: HTTP/3 (with QUIC)

1. Vào tab **Network**
2. Tìm **HTTP/3 (with QUIC)**
3. Bật toggle
4. Sử dụng HTTP/3 protocol (nhanh hơn HTTP/2)

### Bước 6.4: Rocket Loader

1. Vào **Speed** → **Optimization**
2. Tìm **Rocket Loader**
3. **ON** - Load JS asynchronously (có thể gây lỗi một số JS)
4. **OFF** (Mặc định) - Khuyên dùng nếu không chắc

### Bước 6.5: Early Hints

1. Tìm **Early Hints**
2. Bật toggle
3. Cloudflare gửi hints sớm để browser preload resources

---

## 7. CLOUDFLARE API SETUP

### Bước 7.1: Tạo API Token

1. Click vào icon **profile** (góc trên bên phải)
2. Chọn **"My Profile"**
3. Vào tab **"API Tokens"**
4. Click **"Create Token"**

### Bước 7.2: Chọn Template

1. Chọn **"Edit zone DNS"** template (cho DNS management)
2. Hoặc **"Zone Cache Purge"** (cho purge cache)
3. Hoặc **"Custom token"** để tùy chỉnh

### Bước 7.3: Cấu hình Permissions

1. **Zone Resources:**
   - Include: **Specific zone**
   - Zone: Chọn domain của bạn

2. **Permissions:**
   - Zone: DNS:Edit, Zone:Read
   - Account: Zone:Read (nếu cần)

3. Click **"Continue to summary"**
4. Review và click **"Create Token"**
5. **⚠️ QUAN TRỌNG: Copy token ngay (chỉ hiển thị 1 lần!)**

### Bước 7.4: Sử dụng API Token

**Purge Cache:**
```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'
```

**Lấy Zone ID:**
1. Vào dashboard, click vào domain
2. Scroll xuống dưới cùng bên phải
3. Sẽ thấy **Zone ID**

### Bước 7.5: Thêm vào deploy.sh

Mở file `deploy.sh` và cập nhật:
```bash
CLOUDFLARE_ZONE_ID="your-zone-id-here"
CLOUDFLARE_API_TOKEN="your-api-token-here"
CLOUDFLARE_PURGE=true
```

---

## ✅ CHECKLIST HOÀN THÀNH

Sau khi cấu hình xong, kiểm tra:

- [ ] Domain đã được thêm vào Cloudflare
- [ ] Nameservers đã được cập nhật ở domain provider
- [ ] DNS records đã được cấu hình đúng (A records với Proxy ON)
- [ ] SSL/TLS mode đã được set (Full hoặc Full strict)
- [ ] Always Use HTTPS đã được bật
- [ ] Caching đã được cấu hình
- [ ] Security settings đã được set
- [ ] Speed optimizations đã được bật
- [ ] Website truy cập được qua HTTPS
- [ ] SSL certificate hiển thị đúng (khóa xanh)

---

## 🎯 KẾT QUẢ

Sau khi hoàn thành tất cả các bước:

1. ✅ Website có SSL/TLS encryption
2. ✅ CDN đã được kích hoạt (load nhanh hơn)
3. ✅ DDoS protection đã được bật
4. ✅ Caching giúp giảm tải server
5. ✅ Security headers đã được thêm
6. ✅ Website đã được tối ưu tốc độ

**Website của bạn đã được bảo vệ và tối ưu bởi Cloudflare! 🎉**

