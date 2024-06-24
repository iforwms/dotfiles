#!/usr/bin/env bash

# TODO: `termux`: `pkg update` 0 no mirror or group mirror selected
# Make sh-compatible
# Install all packages at once

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
if ! [[ -x "$(command -v pkg)" ]]; then
  echo "[${script_name}] This file must be run in Termux. Exiting..."
  exit 1
fi

echo "[${script_name}] Updating repos..."
pkg update

echo "[${script_name}] Upgrading apps..."
pkg upgrade

echo "[${script_name}] Installing required apps..."
for f in $packages_to_install; do
   pkg install -y "$f"
done

echo "[${script_name}] Creating symlinks..."
termux-setup-storage

# echo "[${script_name}] Setting ZSH as default shell..."
# chsh -s zsh

# echo "[${script_name}] Installing OMZ..."
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "[${script_name}] Downloading iforwms yt script..."
yt_filepath=/data/data/com.termux/files/usr/bin/yt
curl -fsSL https://dl.iforwms.com/yt > "$yt_filepath" && chmod +x "$yt_filepath"

echo "[${script_name}] All done!"
exit 0
