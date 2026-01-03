#!/usr/bin/env bash
set -e

echo "==> Applying KDE Plasma configuration"

CONFIG_SRC="$(pwd)/kde/config"
THEME_SRC="$(pwd)/kde/themes"

# Backup existing config (once)
BACKUP="$HOME/.config/kde-backup"
mkdir -p "$BACKUP"

for f in kdeglobals kwinrc plasmashellrc plasma-org.kde.plasma.desktop-appletsrc breezerc dolphinrc; do
  if [[ -f "$HOME/.config/$f" && ! -f "$BACKUP/$f" ]]; then
    cp "$HOME/.config/$f" "$BACKUP/"
  fi
done

# Link config files
for f in kdeglobals kwinrc plasmarc plasma-org.kde.plasma.desktop-appletsrc breezerc; do
  ln -sf "$CONFIG_SRC/$f" "$HOME/.config/$f"
done

# Install Orchis theme if present
if [[ -d "$THEME_SRC/Orchis" ]]; then
  mkdir -p "$HOME/.local/share/themes"
  ln -sf "$THEME_SRC/Orchis" "$HOME/.local/share/themes/Orchis"
fi

# Apply theme + icons explicitly
plasma-apply-lookandfeel org.kde.breezedark || true
plasma-apply-colorscheme BreezeDark || true
kwriteconfig6 --file kdeglobals --group Icons --key Theme breeze-dark

echo "==> Restarting Plasma"
kquitapp6 plasmashell || true
sleep 2
plasmashell &
