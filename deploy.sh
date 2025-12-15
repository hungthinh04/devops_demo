#!/bin/bash

# Deploy Script - Upload build lên server và reload Nginx
# Sử dụng: chmod +x deploy.sh && ./deploy.sh

set -e  # Dừng ngay khi có lỗi

# ============ CẤU HÌNH ============
# Thay đổi các thông tin sau theo server của bạn:

SERVER_USER="root"                    # User để SSH vào server
SERVER_IP="your-server-ip"            # IP hoặc domain của server
SERVER_PATH="/var/www/my-web-app"     # Đường dẫn trên server
BUILD_DIR="dist"                      # Thư mục build (dist hoặc build)
NGINX_RELOAD=true                     # Có reload Nginx sau khi deploy không
CLOUDFLARE_PURGE=false                # Có purge Cloudflare cache không

# Cloudflare API (nếu muốn auto purge cache)
CLOUDFLARE_ZONE_ID="your-zone-id"
CLOUDFLARE_API_TOKEN="your-api-token"

# ============ KHÔNG CẦN SỬA DƯỚI ĐÂY ============

# Màu sắc
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Bắt đầu deploy process...${NC}"
echo ""

# 1. Build application
echo -e "${YELLOW}📦 Building application...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build thành công${NC}"
echo ""

# 2. Kiểm tra thư mục build
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}❌ Không tìm thấy thư mục $BUILD_DIR${NC}"
    exit 1
fi

# 3. Upload lên server
echo -e "${YELLOW}📤 Uploading files to server...${NC}"
echo -e "${BLUE}   Server: ${SERVER_USER}@${SERVER_IP}${NC}"
echo -e "${BLUE}   Path: ${SERVER_PATH}/${BUILD_DIR}${NC}"
echo ""

# Sử dụng rsync (tốt hơn scp vì chỉ sync files thay đổi)
rsync -avz --delete \
    --exclude '*.map' \
    --exclude '.DS_Store' \
    "${BUILD_DIR}/" \
    "${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/${BUILD_DIR}/"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Upload failed!${NC}"
    echo -e "${YELLOW}💡 Kiểm tra lại:${NC}"
    echo -e "${YELLOW}   - SSH key đã được thêm vào server chưa?${NC}"
    echo -e "${YELLOW}   - Đường dẫn server có đúng không?${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Upload thành công${NC}"
echo ""

# 4. Set permissions trên server
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
ssh "${SERVER_USER}@${SERVER_IP}" "sudo chown -R www-data:www-data ${SERVER_PATH}/${BUILD_DIR} && sudo chmod -R 755 ${SERVER_PATH}/${BUILD_DIR}"

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  Không thể set permissions (có thể cần nhập password)${NC}"
fi

# 5. Reload Nginx
if [ "$NGINX_RELOAD" = true ]; then
    echo -e "${YELLOW}🔄 Reloading Nginx...${NC}"
    ssh "${SERVER_USER}@${SERVER_IP}" "sudo nginx -t && sudo systemctl reload nginx"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Nginx reloaded thành công${NC}"
    else
        echo -e "${RED}❌ Lỗi khi reload Nginx${NC}"
    fi
    echo ""
fi

# 6. Purge Cloudflare cache (nếu có cấu hình)
if [ "$CLOUDFLARE_PURGE" = true ] && [ -n "$CLOUDFLARE_API_TOKEN" ] && [ -n "$CLOUDFLARE_ZONE_ID" ]; then
    echo -e "${YELLOW}🧹 Purging Cloudflare cache...${NC}"
    
    response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/purge_cache" \
        -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
        -H "Content-Type: application/json" \
        --data '{"purge_everything":true}')
    
    if echo "$response" | grep -q '"success":true'; then
        echo -e "${GREEN}✅ Cloudflare cache đã được purge${NC}"
    else
        echo -e "${YELLOW}⚠️  Không thể purge Cloudflare cache${NC}"
        echo "$response"
    fi
    echo ""
fi

# 7. Hoàn thành
echo -e "${GREEN}🎉 Deploy hoàn thành!${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "${BLUE}   1. Kiểm tra website: https://yourdomain.com${NC}"
echo -e "${BLUE}   2. Kiểm tra browser console (F12) xem có lỗi không${NC}"
echo -e "${BLUE}   3. Test tất cả các routes${NC}"

