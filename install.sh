#!/usr/bin/env bash
set -e

./bootstrap.sh
./packages.sh
./services.sh
./link-dotfiles.sh
./apply-kde.sh
./user.sh

echo "🎉 Arch setup complete"
