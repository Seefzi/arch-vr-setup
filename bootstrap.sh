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

