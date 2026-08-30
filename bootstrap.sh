#!/usr/bin/env bash
# ==============================================================================
# One-Liner Quick Bootstrap for Omarchy Preferences Setup
# ==============================================================================

set -euo pipefail

DEST_DIR="$HOME/Work/omarchy-config"

echo "==> Setting up Omarchy preferences..."

# Ensure core prerequisites exist
for pkg in git jq curl; do
  if ! command -v "$pkg" >/dev/null 2>&1; then
    echo "--> Installing missing dependency: $pkg..."
    if command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm "$pkg" || true
    fi
  fi
done

if [[ -d "$DEST_DIR/.git" ]]; then
  echo "--> Repository already exists in $DEST_DIR. Pulling latest..."
  git -C "$DEST_DIR" pull --rebase
else
  mkdir -p "$HOME/Work"
  echo "--> Cloning bchurch95/omarchy-config..."
  git clone https://github.com/bchurch95/omarchy-config.git "$DEST_DIR"
fi

echo "--> Launching restore script..."
bash "$DEST_DIR/restore.sh" "${1:---all}"
