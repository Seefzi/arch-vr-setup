#!/usr/bin/env bash
set -e

echo "==> Updating system"
sudo pacman -Syu --noconfirm

echo "==> Installing base tools"
sudo pacman -S --needed --noconfirm \
  git \
  base-devel \
  curl \
  wget \
  nvim

echo "==> Installing udev rules"
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
