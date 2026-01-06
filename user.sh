if [ "$SHELL" != "/bin/fish" ]; then
  echo "==> Setting fish as default shell"
  chsh -s /bin/fish
fi

echo "==> Installing omf (use 'exit' command once it's done)"

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# ---- pacman parallel downloads ----
PACMAN_CONF="/etc/pacman.conf"

echo "==> Configuring pacman"

# Uncomment Color + VerbosePkgLists if present
sudo sed -i 's/^#Color/Color/' "$PACMAN_CONF"
sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' "$PACMAN_CONF"

# Enable ParallelDownloads (set to 5 if commented or missing)
if grep -q '^#ParallelDownloads' "$PACMAN_CONF"; then
  sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' "$PACMAN_CONF"
elif ! grep -q '^ParallelDownloads' "$PACMAN_CONF"; then
  sudo sed -i '/^\[options\]/a ParallelDownloads = 5' "$PACMAN_CONF"
fi

# Enable ILoveCandy
if ! grep -q '^ILoveCandy' "$PACMAN_CONF"; then
  sudo sed -i '/^\[options\]/a ILoveCandy' "$PACMAN_CONF"
fi

echo "==> Installing Layan theme"
git clone https://github.com/vinceliuice/Layan-kde.git
./Layan-kde/install.sh
