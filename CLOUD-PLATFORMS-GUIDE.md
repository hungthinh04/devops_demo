# ☁️ HƯỚNG DẪN TRUY CẬP CÁC CLOUD PLATFORMS

Hướng dẫn chi tiết cách đăng ký và truy cập các nhà cung cấp VPS/Cloud phổ biến.

---

## 📋 MỤC LỤC

1. [DigitalOcean](#1-digitalocean)
2. [AWS EC2](#2-aws-ec2)
3. [Google Cloud Platform](#3-google-cloud-platform)
4. [Vultr](#4-vultr)
5. [Linode](#5-linode)
6. [Azure](#6-azure)

---

## 1. DIGITALOCEAN

### Đăng ký tài khoản

1. Truy cập: **https://www.digitalocean.com**
2. Click **"Sign Up"** ở góc trên bên phải
3. Điền thông tin:
   - Email address
   - Password (tối thiểu 8 ký tự)
   - Hoặc đăng nhập bằng Google/GitHub
4. Xác nhận email qua link trong inbox

### Nhận $200 Credit miễn phí

1. Sau khi đăng nhập, vào **Settings** → **Billing**
2. Nếu có promo code, nhập vào
3. Hoặc dùng link giới thiệu để nhận credit

### Tạo Droplet (VPS)

1. Click **"Create"** ở góc trên → **"Droplets"**
2. Chọn **Distribution**:
   - **Ubuntu 22.04 (LTS) x64** (Khuyên dùng)
   - Hoặc Ubuntu 20.04, Debian, CentOS
3. Chọn **Plan**:
   - **Basic** → **Regular with SSD**
   - **$6/month** (1GB RAM, 1 vCPU) - Đủ cho web nhỏ
   - **$12/month** (2GB RAM) - Tốt hơn
4. Chọn **Datacenter region**:
   - **Singapore** (gần Việt Nam nhất)
   - Hoặc Frankfurt, New York
5. **Authentication**:
   - **SSH keys** (Khuyên dùng - an toàn hơn)
     - Click "New SSH Key"
     - Copy public key từ máy local: `cat ~/.ssh/id_rsa.pub`
     - Paste vào và đặt tên
   - **Password** (nếu chưa có SSH key)
6. **Hostname**: Đặt tên cho server (ví dụ: `web-server-1`)
7. Click **"Create Droplet"**
8. Đợi 1-2 phút để server được tạo

### Kết nối SSH

1. Sau khi droplet được tạo, bạn sẽ thấy IP address
2. Click vào droplet để xem chi tiết
3. Click **"Access"** → **"Launch Droplet Console"** (trình duyệt)
   - Hoặc dùng SSH từ terminal:
   ```bash
   ssh root@YOUR_DROPLET_IP
   ```
4. Lần đầu sẽ hỏi xác nhận, gõ `yes`
5. Nhập password (nếu dùng password) hoặc tự động login (nếu dùng SSH key)

### Giá cả

- **Basic**: $6/tháng (1GB RAM) - Đủ cho web nhỏ
- **Basic**: $12/tháng (2GB RAM) - Khuyên dùng
- **Basic**: $18/tháng (4GB RAM) - Cho app lớn hơn

---

## 2. AWS EC2

### Đăng ký tài khoản

1. Truy cập: **https://aws.amazon.com**
2. Click **"Create an AWS Account"** hoặc **"Sign In"**
3. Điền thông tin:
   - Email address
   - Password
   - Account name
4. Điền thông tin thanh toán (cần credit card)
   - **12 tháng Free Tier** cho t2.micro instance
5. Xác nhận identity qua phone

### Truy cập EC2 Console

1. Sau khi đăng nhập, vào **Services** → **EC2**
2. Hoặc truy cập trực tiếp: **https://console.aws.amazon.com/ec2**

### Tạo EC2 Instance

1. Trong EC2 Dashboard, click **"Launch Instance"**
2. **Name**: Đặt tên (ví dụ: `web-server`)
3. **Application and OS Images**:
   - **Ubuntu Server 22.04 LTS** (Free tier eligible)
4. **Instance Type**:
   - **t2.micro** (Free tier - 1GB RAM)
   - **t3.small** ($0.0208/hour ≈ $15/tháng - 2GB RAM)
5. **Key Pair**:
   - Click **"Create new key pair"**
   - Tên: `my-key-pair`
   - Format: `.pem`
   - Click **"Create key pair"**
   - **⚠️ Lưu file .pem này ngay (không thể tải lại!)**
6. **Network settings**:
   - **Security group**: Create new
   - **Allow SSH from**: My IP (hoặc Anywhere-IPv4 cho test)
   - **Allow HTTP**: Anywhere-IPv4
   - **Allow HTTPS**: Anywhere-IPv4
7. **Configure storage**: 8GB (Free tier) hoặc 20GB
8. Click **"Launch Instance"**

### Kết nối SSH

1. Đợi instance chạy (Status: Running)
2. Click vào instance → **"Connect"**
3. Copy command SSH, ví dụ:
   ```bash
   ssh -i "my-key-pair.pem" ubuntu@ec2-xx-xx-xx-xx.compute.amazonaws.com
   ```
4. Chạy command từ terminal (đảm bảo file .pem có quyền đúng):
   ```bash
   chmod 400 my-key-pair.pem
   ssh -i "my-key-pair.pem" ubuntu@ec2-xx-xx-xx-xx.compute.amazonaws.com
   ```

### Lưu ý

- **Free Tier**: 750 giờ/tháng cho t2.micro (chạy 1 instance cả tháng free)
- Sau free tier, t2.micro: ~$8-10/tháng
- Tài khoản mới có thể nhận $300 credit trong 12 tháng

---

## 3. GOOGLE CLOUD PLATFORM

### Đăng ký tài khoản

1. Truy cập: **https://cloud.google.com**
2. Click **"Get started for free"**
3. Đăng nhập bằng Google Account
4. Điền thông tin:
   - Country
   - Account type (Individual/Company)
5. Điền thông tin thanh toán (cần credit card)
   - **$300 free credit trong 90 ngày đầu**
6. Xác nhận email

### Tạo Project

1. Vào **Console**: **https://console.cloud.google.com**
2. Click dropdown project ở trên cùng
3. Click **"New Project"**
4. Điền:
   - Project name: `my-web-app`
   - Organization: (để trống nếu cá nhân)
5. Click **"Create"**

### Tạo VM Instance

1. Vào **Compute Engine** → **VM instances**
2. Click **"Create Instance"**
3. **Name**: `web-server`
4. **Region**: `asia-southeast1` (Singapore) hoặc `asia-east1` (Taiwan)
5. **Machine configuration**:
   - **Series**: E2
   - **Machine type**: `e2-micro` (Free tier - 0.25 vCPU, 1GB RAM)
     - Hoặc `e2-small` ($0.033/hour ≈ $24/tháng)
6. **Boot disk**:
   - **OS**: Ubuntu
   - **Version**: Ubuntu 22.04 LTS
   - **Size**: 10GB (free tier) hoặc 20GB
7. **Firewall**:
   - ✅ Allow HTTP traffic
   - ✅ Allow HTTPS traffic
8. Click **"Create"**

### Kết nối SSH

1. Sau khi instance chạy, click **"SSH"** button (trình duyệt)
   - Hoặc dùng gcloud CLI:
   ```bash
   # Cài gcloud CLI trước
   gcloud compute ssh web-server --zone=asia-southeast1-a
   ```
2. Hoặc dùng SSH key thông thường

### Lưu ý

- **Free Tier**: e2-micro miễn phí mỗi tháng (giới hạn usage)
- **$300 credit** trong 90 ngày đầu (đủ để test nhiều)
- Sau free tier, e2-micro: ~$6-8/tháng

---

## 4. VULTR

### Đăng ký tài khoản

1. Truy cập: **https://www.vultr.com**
2. Click **"Sign Up"**
3. Điền email và password
4. Xác nhận email

### Tạo Instance

1. Click **"Deploy Server"** hoặc **"Products"** → **"Compute"**
2. Chọn **Cloud Compute**
3. **Server Location**: Chọn datacenter gần (Singapore, Tokyo)
4. **Server Type**: **Regular Performance**
5. **OS**: **Ubuntu 22.04 LTS**
6. **Server Plan**:
   - **$6/month** (1GB RAM, 1 vCPU, 25GB SSD)
   - **$12/month** (2GB RAM) - Khuyên dùng
7. **SSH Keys**: Thêm SSH key (khuyên dùng)
8. **Server Hostname**: Đặt tên
9. Click **"Deploy Now"**

### Kết nối SSH

```bash
ssh root@YOUR_SERVER_IP
```

### Giá cả

- **$6/month** (1GB RAM) - Rẻ nhất trong các options
- **$12/month** (2GB RAM)
- **$24/month** (4GB RAM)

---

## 5. LINODE (AKAMAI)

### Đăng ký tài khoản

1. Truy cập: **https://www.linode.com**
2. Click **"Sign Up"**
3. Điền thông tin và xác nhận email
4. Điền thông tin thanh toán

### Tạo Linode

1. Click **"Create"** → **"Linode"**
2. **Distribution**: **Ubuntu 22.04 LTS**
3. **Region**: Singapore, Tokyo, hoặc Fremont
4. **Linode Plan**:
   - **Nanode 1GB** ($5/month - 1GB RAM)
   - **Linode 2GB** ($12/month - 2GB RAM)
5. **Linode Label**: Đặt tên
6. **Root Password**: Đặt password mạnh
7. **SSH Keys**: Thêm SSH key
8. Click **"Create Linode"**

### Kết nối SSH

```bash
ssh root@YOUR_LINODE_IP
```

### Giá cả

- **$5/month** (1GB RAM) - Rẻ nhất
- **$12/month** (2GB RAM)

---

## 6. AZURE

### Đăng ký tài khoản

1. Truy cập: **https://azure.microsoft.com**
2. Click **"Start free"**
3. Đăng nhập bằng Microsoft Account
4. Điền thông tin và xác nhận identity
5. Điền thông tin thanh toán
   - **$200 credit miễn phí trong 30 ngày đầu**

### Tạo Virtual Machine

1. Vào **Portal**: **https://portal.azure.com**
2. Click **"Create a resource"**
3. Tìm **"Virtual Machine"** → Click **"Create"**
4. **Subscription**: Chọn subscription
5. **Resource group**: Tạo mới
6. **VM name**: `web-server`
7. **Region**: Southeast Asia
8. **Image**: **Ubuntu Server 22.04 LTS**
9. **Size**: **Standard_B1s** (Free tier - 1GB RAM)
10. **Authentication type**: SSH public key
11. **Inbound ports**: Allow SSH (22), HTTP (80), HTTPS (443)
12. Click **"Review + create"** → **"Create"**

### Kết nối SSH

1. Sau khi VM chạy, click vào VM
2. Click **"Connect"** → **"SSH"**
3. Copy command và chạy

---

## 📊 SO SÁNH CÁC PLATFORMS

| Platform | Giá thấp nhất | Free Tier | Credit mới | Khuyên dùng cho |
|----------|---------------|-----------|------------|-----------------|
| **DigitalOcean** | $6/tháng | ❌ | $200 | Người mới bắt đầu |
| **AWS EC2** | ~$8/tháng | ✅ 12 tháng | $300 | Enterprise, scale lớn |
| **Google Cloud** | ~$6/tháng | ✅ | $300 | Developers, ML/AI |
| **Vultr** | $6/tháng | ❌ | - | Budget, performance |
| **Linode** | $5/tháng | ❌ | - | Rẻ nhất, đơn giản |
| **Azure** | ~$10/tháng | ✅ 12 tháng | $200 | Enterprise, Microsoft stack |

---

## 💡 KHUYẾN NGHỊ

### Cho người mới bắt đầu:
1. **DigitalOcean** - Dễ dùng, documentation tốt
2. **Vultr/Linode** - Rẻ, đơn giản

### Cho có kinh nghiệm:
1. **AWS EC2** - Nhiều tính năng, scale tốt
2. **Google Cloud** - Tốt cho development

### Cho budget thấp:
1. **Linode** ($5/tháng) - Rẻ nhất
2. **Vultr** ($6/tháng)
3. **AWS/GCP Free Tier** - Dùng trong 12 tháng đầu

---

## 🔐 LƯU Ý BẢO MẬT

1. **Luôn dùng SSH keys** thay vì password
2. **Disable root login** bằng password (chỉ dùng SSH key)
3. **Setup firewall** (UFW) trên server
4. **Update system** thường xuyên: `sudo apt update && sudo apt upgrade`
5. **Đổi port SSH** mặc định (22) nếu cần
6. **Sử dụng fail2ban** để chống brute force

---

## ✅ CHECKLIST SAU KHI TẠO SERVER

- [ ] Đã kết nối SSH thành công
- [ ] Đã chạy script `server-setup.sh`
- [ ] Đã clone code từ GitHub
- [ ] Đã build application
- [ ] Đã cấu hình Nginx
- [ ] Đã test website (HTTP)
- [ ] Đã setup Cloudflare
- [ ] Đã tạo SSL certificate
- [ ] Website chạy HTTPS thành công

---

**Chúc bạn chọn được platform phù hợp! 🚀**

