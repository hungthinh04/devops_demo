#!/bin/bash

# Server Setup Script - Tự động cài đặt môi trường trên server
# Sử dụng: chmod +x server-setup.sh && sudo ./server-setup.sh

set -e

# Màu sắc
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Bắt đầu setup server...${NC}"
echo ""

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Vui lòng chạy script với sudo${NC}"
    exit 1
fi

# 1. Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
apt update && apt upgrade -y
echo -e "${GREEN}✅ System updated${NC}"
echo ""

# 2. Cài đặt Nginx
echo -e "${YELLOW}🌐 Installing Nginx...${NC}"
apt install nginx -y
systemctl start nginx
systemctl enable nginx
echo -e "${GREEN}✅ Nginx installed and started${NC}"
echo ""

# 3. Cài đặt Node.js (optional - chỉ cần nếu build trên server)
read -p "Có cần cài đặt Node.js? (y/n): " install_node
if [ "$install_node" = "y" ]; then
    echo -e "${YELLOW}📦 Installing Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
    echo -e "${GREEN}✅ Node.js $(node --version) installed${NC}"
    echo -e "${GREEN}✅ npm $(npm --version) installed${NC}"
    echo ""
fi

# 4. Cài đặt Git
echo -e "${YELLOW}📥 Installing Git...${NC}"
apt install git -y
echo -e "${GREEN}✅ Git installed${NC}"
echo ""

# 5. Cài đặt Certbot (cho SSL)
echo -e "${YELLOW}🔒 Installing Certbot...${NC}"
apt install certbot python3-certbot-nginx -y
echo -e "${GREEN}✅ Certbot installed${NC}"
echo ""

# 6. Cài đặt các tools hữu ích
echo -e "${YELLOW}🛠️  Installing useful tools...${NC}"
apt install -y curl wget nano htop ufw
echo -e "${GREEN}✅ Tools installed${NC}"
echo ""

# 7. Cấu hình Firewall
echo -e "${YELLOW}🔥 Configuring Firewall...${NC}"
ufw allow 'Nginx Full'
ufw allow 'OpenSSH'
ufw --force enable
echo -e "${GREEN}✅ Firewall configured${NC}"
echo ""

# 8. Tạo thư mục cho web apps
echo -e "${YELLOW}📁 Creating web directory...${NC}"
mkdir -p /var/www
chown -R $SUDO_USER:$SUDO_USER /var/www
echo -e "${GREEN}✅ Directory created at /var/www${NC}"
echo ""

# 9. Hiển thị thông tin
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Server setup hoàn tất!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📊 Thông tin hệ thống:${NC}"
echo -e "   Nginx version: $(nginx -v 2>&1 | cut -d/ -f2)"
if command -v node &> /dev/null; then
    echo -e "   Node.js version: $(node --version)"
    echo -e "   npm version: $(npm --version)"
fi
echo -e "   Git version: $(git --version | cut -d' ' -f3)"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "   1. Clone code vào /var/www/your-project"
echo -e "   2. Build application (npm run build)"
echo -e "   3. Cấu hình Nginx (xem nginx.conf.example)"
echo -e "   4. Tạo SSL certificate (sudo certbot --nginx -d yourdomain.com)"
echo ""
echo -e "${GREEN}🎉 Hoàn thành!${NC}"

