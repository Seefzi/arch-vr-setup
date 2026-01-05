#!/usr/bin/env bash
set -e

if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
fi

sudo pacman -S --needed --noconfirm $(< packages/base.txt)
yay -S --needed --noconfirm $(< packages/aur.txt)

echo
read -rp "Install gaming / VR packages? [Y/n] " GAMING
GAMING=${GAMING,,}

if [[ -z "$GAMING" || "$GAMING" == "y" || "$GAMING" == "yes" ]]; then
  echo "==> Installing gaming packages"
  yay -S --needed --noconfirm $(< packages/gaming.txt)
  echo "==> Installing PlatformIO's udev rules for SlimeVR compatibility"
  curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
else
  echo "==> Skipping gaming setup"
fi
