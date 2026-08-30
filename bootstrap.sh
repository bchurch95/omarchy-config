#!/usr/bin/env bash
# ==============================================================================
# One-Liner Quick Bootstrap for Omarchy Preferences Setup
# ==============================================================================

set -euo pipefail

DEST_DIR="$HOME/Work/omarchy-config"

echo "==> Setting up Omarchy preferences..."

if ! command -v git >/dev/null 2>&1; then
  echo "--> Installing git..."
  sudo pacman -S --noconfirm git
fi

if [[ -d "$DEST_DIR" ]]; then
  echo "--> Repository already exists in $DEST_DIR. Pulling latest..."
  git -C "$DEST_DIR" pull --rebase
else
  mkdir -p "$HOME/Work"
  echo "--> Cloning bchurch95/omarchy-config..."
  git clone https://github.com/bchurch95/omarchy-config.git "$DEST_DIR"
fi

echo "--> Launching restore script..."
bash "$DEST_DIR/restore.sh" "${1:---all}"
