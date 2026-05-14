#!/data/data/com.termux/files/usr/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

printf "${CYAN}"
printf "  +==================================+\n"
printf "  |       Auto Install Apps          |\n"
printf "  |  ZArchiver . MT Manager          |\n"
printf "  |       Rotation Control           |\n"
printf "  +==================================+\n"
printf "${NC}\n"

printf "${YELLOW}[*] Xin quyen truy cap bo nho...${NC}\n"
termux-setup-storage
sleep 2

printf "${YELLOW}[*] Cap nhat package...${NC}\n"
pkg update -y -q
pkg install wget -y -q

DOWNLOAD_DIR="$HOME/storage/downloads/AutoInstall"
mkdir -p "$DOWNLOAD_DIR"

install_app() {
    NAME="$1"
    URL="$2"
    FILE="$DOWNLOAD_DIR/${NAME}.apk"

    printf "\n${YELLOW}[down] Dang tai: ${NAME}...${NC}\n"

    wget \
        --user-agent="Mozilla/5.0 (Linux; Android 13; Mobile)" \
        -L \
        --no-check-certificate \
        --show-progress \
        -O "$FILE" \
        "$URL"

    if [ -f "$FILE" ] && [ -s "$FILE" ]; then
        printf "${GREEN}[OK] Tai xong: ${NAME}${NC}\n"
        printf "${CYAN}[*] Mo cai dat ${NAME}... Bam 'Cai dat' roi nhan ENTER de tiep tuc${NC}\n"
        termux-open "$FILE"
        read -r dummy
    else
        printf "${RED}[X] Loi tai: ${NAME}${NC}\n"
    fi
}

install_app "ZArchiver"        "https://d.apkpure.com/b/APK/ru.zdevs.zarchiver?version=latest"
install_app "MT_Manager"       "https://d.apkpure.com/b/APK/bin.mt.plus?version=latest"
install_app "Rotation_Control" "https://d.apkpure.com/b/APK/ahapps.controlthescreenorientation?version=latest"

printf "\n${GREEN}+==================================+${NC}\n"
printf "${GREEN}|    Cai xong tat ca app!          |${NC}\n"
printf "${GREEN}+==================================+${NC}\n"