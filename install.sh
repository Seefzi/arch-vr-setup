#!/usr/bin/env bash
set -e

./bootstrap.sh
./packages.sh
./services.sh
./link-dotfiles.sh
./user.sh

echo "🎉 Arch setup complete"
echo "Still todo:"
echo "Configure Dolphin startup"
echo "Turn off mouse acceleration"
echo "Turn off screen edge"
echo "Turn off wiggle cursor"
echo "Apply Orchis Theme"
echo "Apply Orchis kvantum Theme"
echo "Apply kvantum colors"
echo "Apply kvantum application style"
echo "Apply Breeze Dark icons"
echo "Apply Oxygen Zion cursors"
