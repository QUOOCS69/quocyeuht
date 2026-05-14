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

pkg update -y -q
pkg install wget -y -q

DOWNLOAD_DIR="$HOME/AutoInstall"
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
        printf "${YELLOW}[*] Dang cai: ${NAME}...${NC}\n"
        su -c "pm install -r \"$FILE\""
        if [ $? -eq 0 ]; then
            printf "${GREEN}[OK] Cai xong: ${NAME}${NC}\n"
        else
            printf "${RED}[X] Loi cai: ${NAME}${NC}\n"
        fi
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

rm -rf "$DOWNLOAD_DIR"