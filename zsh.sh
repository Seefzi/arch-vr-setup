#!/usr/bin/env bash
set -e

export ZSH="$HOME/.oh-my-zsh"

if [ ! -d "$ZSH" ]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> Oh My Zsh already installed"
fi

AUTOCOMP_DIR="$ZSH/custom/plugins/zsh-autocomplete"

if [ ! -d "$AUTOCOMP_DIR" ]; then
  echo "==> Installing zsh-autocomplete"
  git clone https://github.com/marlonrichert/zsh-autocomplete.git "$AUTOCOMP_DIR"
  echo "==> Installing zsh-completions"
  git clone https://github.com/zsh-users/zsh-completions.git "$AUTOCOMP_DIR"
fi


