#!/usr/bin/env bash
set -e

# ---- resolve real user ----
REAL_USER="${SUDO_USER:-$USER}"
REAL_UID="$(id -u "$REAL_USER")"
REAL_GID="$(id -g "$REAL_USER")"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

echo "==> Using user: $REAL_USER (uid=$REAL_UID gid=$REAL_GID)"

# ---- services ----
services=(
  sshd
  bluetooth
  avahi-daemon
)

for s in "${services[@]}"; do
  sudo systemctl enable --now "$s"
done

# ---- ask about kyurem servers ----
read -rp "Would you like to configure Zekrom SMB mounts? [y/N]: " SETUP_KYUREM
SETUP_KYUREM=${SETUP_KYUREM,,} # lowercase

if [[ "$SETUP_KYUREM" != "y" && "$SETUP_KYUREM" != "yes" ]]; then
  echo "==> Skipping Zekrom server setup"
  exit 0
fi

# ---- SMB credentials ----
CREDS_FILE="$REAL_HOME/.smbcreds"

if [ ! -f "$CREDS_FILE" ]; then
  echo "==> Creating SMB credentials file"

  read -rp "SMB username: " SMB_USER
  read -rsp "SMB password: " SMB_PASS
  echo

  sudo tee "$CREDS_FILE" > /dev/null <<EOF
username=$SMB_USER
password=$SMB_PASS
EOF

  sudo chown "$REAL_UID:$REAL_GID" "$CREDS_FILE"
  sudo chmod 600 "$CREDS_FILE"
else
  echo "==> SMB credentials already exist"
fi

# ---- fstab block ----
FSTAB="/etc/fstab"
MARKER="# === zekrom servers ==="

KYUREM_FSTAB=$(cat <<EOF
# === zekrom servers ===
# zekrom active server
//zekrom/int-ssd   /net/zekrom   cifs   credentials=/home/kerfus/.smbcreds,iocharset=utf8,nofail,x-systemd.automount,uid=1000,gid=1000   0 0

# zekrom legacy server
//zekrom/ext-ssd   /net/zekrom-legacy   cifs   credentials=/home/kerfus/.smbcreds,iocharset=utf8,nofail,x-systemd.automount,uid=1000,gid=1000   0 0

# kyurem archive server
//zekrom/ext-hdd /net/zekrom-archive   cifs   credentials=/home/kerfus/.smbcreds,iocharset=utf8,nofail,x-systemd.automount,uid=1000,gid=1000   0 0
EOF
)

# ---- mount points ----
sudo mkdir -p /media/kyurem-s /media/kyurem-a
sudo chown "$REAL_UID:$REAL_GID" /media/kyurem-s /media/kyurem-a

# ---- append fstab once ----
if ! sudo grep -qF "$MARKER" "$FSTAB"; then
  echo "==> Adding kyurem mounts to fstab"
  echo "$KYUREM_FSTAB" | sudo tee -a "$FSTAB" > /dev/null
else
  echo "==> kyurem mounts already configured"
fi

# ---- reload + mount (non-fatal) ----
sudo systemctl daemon-reload

echo "==> Attempting to mount filesystems"
if ! sudo mount -a; then
  echo "⚠️  mount -a failed (this is non-fatal, continuing)"
fi
