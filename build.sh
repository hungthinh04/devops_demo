#!/bin/bash

# Build Script cho Web Application
# Sử dụng: chmod +x build.sh && ./build.sh

set -e  # Dừng ngay khi có lỗi

echo "🚀 Bắt đầu build process..."
echo ""

# Màu sắc cho output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kiểm tra Node.js và npm
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js chưa được cài đặt!${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm chưa được cài đặt!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js version: $(node --version)${NC}"
echo -e "${GREEN}✅ npm version: $(npm --version)${NC}"
echo ""

# Kiểm tra package.json
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Không tìm thấy package.json!${NC}"
    exit 1
fi

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
npm install

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Lỗi khi install dependencies!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependencies đã được cài đặt${NC}"
echo ""

# Build production
echo -e "${YELLOW}🔨 Building production bundle...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Lỗi khi build!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Build thành công!${NC}"

# Kiểm tra thư mục output
if [ -d "dist" ]; then
    echo -e "${GREEN}📁 Output directory: dist/${NC}"
    echo -e "${GREEN}📊 Size: $(du -sh dist | cut -f1)${NC}"
elif [ -d "build" ]; then
    echo -e "${GREEN}📁 Output directory: build/${NC}"
    echo -e "${GREEN}📊 Size: $(du -sh build | cut -f1)${NC}"
else
    echo -e "${YELLOW}⚠️  Không tìm thấy thư mục dist/ hoặc build/${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Hoàn thành!${NC}"

