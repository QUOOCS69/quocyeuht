#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════╗"
echo "  ║       Auto Install Apps          ║"
echo "  ║     ZArchiver · MT Manager       ║"
echo "  ║       Rotation Control           ║"
echo "  ╚══════════════════════════════════╝"
echo -e "${NC}"

# Xin quyền storage
echo -e "${YELLOW}[*] Xin quyền truy cập bộ nhớ...${NC}"
termux-setup-storage
sleep 2

# Cài wget
pkg install wget -y -q

DOWNLOAD_DIR="$HOME/storage/downloads/AutoInstall"
mkdir -p "$DOWNLOAD_DIR"

install_app() {
    local NAME=$1
    local URL=$2
    local FILE="$DOWNLOAD_DIR/${NAME}.apk"

    echo ""
    echo -e "${YELLOW}[↓] Đang tải: ${NAME}...${NC}"
    wget --user-agent="Mozilla/5.0 (Android 13; Mobile)" \
         -L -q --show-progress -O "$FILE" "$URL"

    if [ -f "$FILE" ] && [ -s "$FILE" ]; then
        echo -e "${GREEN}[✓] Tải xong: ${NAME}${NC}"
        echo -e "${CYAN}[*] Mở cài đặt ${NAME}... Bấm 'Cài đặt' rồi ENTER để tiếp tục${NC}"
        termux-open "$FILE"
        read -r
    else
        echo -e "${RED}[✗] Lỗi tải: ${NAME}${NC}"
    fi
}

install_app "ZArchiver"       "https://d.apkpure.com/b/APK/ru.zdevs.zarchiver?version=latest"
install_app "MT_Manager"      "https://d.apkpure.com/b/APK/bin.mt.plus?version=latest"
install_app "Rotation_Control" "https://d.apkpure.com/b/APK/ahapps.controlthescreenorientation?version=latest"

echo ""
echo -e "${GREEN}  ╔══════════════════════════════════╗${NC}"
echo -e "${GREEN}  ║     Cài xong tất cả app! ✓       ║${NC}"
echo -e "${GREEN}  ╚══════════════════════════════════╝${NC}"