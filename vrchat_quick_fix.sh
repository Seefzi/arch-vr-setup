#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  # If correct symlink already exists, do nothing
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "==> Already linked: $dst"
    return
  fi

  # Backup existing file/dir/symlink
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "==> Backed up existing $dst"
  fi

  ln -s "$src" "$dst"
  echo "==> Linked $dst → $src"
}

# ---- 1) SteamVR bindings ----
BINDINGS_SRC="$REPO_ROOT/extras/bindings_oculus_touch.json"
BINDINGS_DST="$HOME/.local/share/Steam/steamapps/common/VRChat/VRChat_Data/StreamingAssets/SteamVR/bindings_oculus_touch.json"

if [ ! -f "$BINDINGS_SRC" ]; then
  echo "ERROR: bindings file not found: $BINDINGS_SRC"
  exit 1
fi

link "$BINDINGS_SRC" "$BINDINGS_DST"

# ---- 2) VRChat Pictures ----
PICTURES_SRC="$HOME/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures"
PICTURES_DST="$HOME/Pictures/VRChat"

if [ ! -d "$PICTURES_SRC" ]; then
  echo "WARNING: VRChat Pictures directory not found:"
  echo "         $PICTURES_SRC"
  echo "         (VRChat may not have been run yet)"
else
  link "$PICTURES_SRC" "$PICTURES_DST"
fi
