#!/usr/bin/env bash

GREEN='\033[0;32m'
NC='\033[0m'

script_name="termux-init"
packages_to_install="
  ffmpeg
  python
  build-essential
  file
  curl
  termux-api
  zsh
  which
  git
  imagemagick
  jq
  vim
"

command -v pkg >/dev/null 2>&1 || { echo >&2 "[${script_name}] This file must be run in Termux. Exiting..."; exit 1; }

# if ! command -v pkg &> /dev/null; then
#   echo "${GREEN}[${script_name}] This file must be run in Termux. Exiting...${NC}"
#   exit 1
# fi

echo "${GREEN}[${script_name}] Updating repos...${NC}"
pkg update

echo "${GREEN}[${script_name}] Upgrading apps...${NC}"
pkg upgrade -y

echo "${GREEN}[${script_name}] Installing required apps...${NC}"
for f in $packages_to_install; do
   pkg install -y "$f"
done

echo "${GREEN}[${script_name}] Creating symlinks...${NC}"
termux-setup-storage

echo "${GREEN}[${script_name}] Installing yt-dlp...${NC}"
pip install -U --no-deps yt-dlp

# echo "${GREEN}[${script_name}] Setting ZSH as default shell...${NC}"
# chsh -s zsh

# echo "${GREEN}[${script_name}] Installing OMZ...${NC}"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "${GREEN}[${script_name}] Downloading iforwms yt script...${NC}"
yt_filepath=/data/data/com.termux/files/usr/bin/yt
curl -fsSL https://dl.iforwms.com/termux/yt > "$yt_filepath" && chmod +x "$yt_filepath"

echo "${GREEN}[${script_name}] Updating .bashrc...${NC}"
curl -fsSL https://dl.iforwms.com/termux/.bashrc > "${HOME}/.bashrc"

echo "${GREEN}[${script_name}] Updating termux properties...${NC}"
mkdir "${HOME}/.termux" 2>/dev/null
curl -fsSL https://dl.iforwms.com/termux/termux.properties > "${HOME}/.termux/termux.properties"

echo "${GREEN}[${script_name}] Updating vi mode cursors...${NC}"
echo "set vi-ins-mode-string \\1\\e[6 q\\2" > "${HOME}/.inputrc"
echo "set vi-cmd-mode-string \\1\\e[2 q\\2" >> "${HOME}/.inputrc"

echo "${GREEN}[${script_name}] Sourcing .bashrc...${NC}"

source "${HOME}/.bashrc"

echo "${GREEN}[${script_name}] All done!${NC}"
exit 0
