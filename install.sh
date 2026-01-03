#!/usr/bin/env bash
set -e

./bootstrap.sh
./packages.sh
./services.sh
./link-dotfiles.sh
./user.sh

echo "🎉 Arch setup complete"
