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
MARKER="# === kyurem servers ==="

KYUREM_FSTAB=$(cat <<EOF
# === kyurem servers ===
# kyurem active server
//kyurem/speed   /media/kyurem-s   cifs   credentials=$REAL_HOME/.reshcreds,iocharset=utf8,nofail,x-systemd.automount,uid=$REAL_UID,gid=$REAL_GID   0 0

# kyurem hoard server
//kyurem/archive /media/kyurem-a   cifs   credentials=$REAL_HOME/.reshcreds,iocharset=utf8,nofail,x-systemd.automount,uid=$REAL_UID,gid=$REAL_GID   0 0
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

sudo systemctl daemon-reload
sudo mount -a
