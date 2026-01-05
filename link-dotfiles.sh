#!/usr/bin/env bash
set -e

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dotfiles"

link() {
  local src="$DOTDIR/$1"
  local dst="$HOME/$1"

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dst")"

  # If correct symlink already exists, do nothing
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi

  # Backup real files or wrong symlinks
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
  fi

  ln -s "$src" "$dst"
  echo "Linked $dst → $src"
}

# ---- actual links ----
link .config/nvim
link .config/kitty
link .config/wlxoverlay
link .config/envision
link .config/fish
