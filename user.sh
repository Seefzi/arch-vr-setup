if [ "$SHELL" != "/bin/fish" ]; then
  echo "==> Setting fish as default shell"
  chsh -s /bin/fish
fi

echo "==> Configuring pacman"

PACMAN_CONF="/etc/pacman.conf"

sudo sed -i 's/^#Color/Color/' "$PACMAN_CONF"
sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' "$PACMAN_CONF"

if ! grep -q '^ILoveCandy' "$PACMAN_CONF"; then
  sudo sed -i '/^\[options\]/a ILoveCandy' "$PACMAN_CONF"
fi

