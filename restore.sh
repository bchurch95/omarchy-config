#!/usr/bin/env bash
# ==============================================================================
# Omarchy User Preferences & Desktop Restoration Script
# Repository: https://github.com/bchurch95/omarchy-config
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/configs"

BOLD="$(tput bold 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
BLUE="$(tput setaf 4 2>/dev/null || echo '')"
RESET="$(tput sgr0 2>/dev/null || echo '')"

log_info()    { echo "${BLUE}${BOLD}==>${RESET} $*"; }
log_success() { echo "${GREEN}${BOLD} [OK]${RESET} $*"; }
log_warn()    { echo "${YELLOW}${BOLD}[WARN]${RESET} $*"; }

usage() {
  cat <<EOF
${BOLD}Omarchy Preferences Restore Tool${RESET}

Usage: $0 [option]

Options:
  --all         Deploy all user configurations and synchronize shell plugins
  --configs     Deploy only user configurations (~/.config, ~/.local/bin, ~/.local/share)
  --plugins     Clone and synchronize all curated plugins via bchurch95/omarchy-plugins
  --help        Show this help message

Running without arguments will launch the interactive menu.
EOF
}

restore_user_configs() {
  log_info "Restoring User Configurations (~/.config, ~/.local)..."

  # Hyprland
  mkdir -p "$HOME/.config/hypr"
  cp -v "$CONFIGS_DIR/hypr/"*.lua "$HOME/.config/hypr/"
  log_success "Hyprland configs restored (bindings, looknfeel, input, monitors, autostart)."

  # Omarchy Shell & Bar Modules
  mkdir -p "$HOME/.config/omarchy/bar/modules"
  cp -v "$CONFIGS_DIR/omarchy/shell.json" "$HOME/.config/omarchy/shell.json"
  cp -v "$CONFIGS_DIR/omarchy/bar/modules/"*.qml "$HOME/.config/omarchy/bar/modules/"
  log_success "Omarchy shell layout and custom bar modules (sysinfo, kdeconnect) restored."

  # Custom Plugins (ben.apple-music-button)
  if [[ -d "$CONFIGS_DIR/plugins/ben.apple-music-button" ]]; then
    mkdir -p "$HOME/.config/omarchy/plugins/ben.apple-music-button"
    cp -rv "$CONFIGS_DIR/plugins/ben.apple-music-button/"* "$HOME/.config/omarchy/plugins/ben.apple-music-button/"
    log_success "Local plugin ben.apple-music-button restored."
  fi

  # Custom Themes
  if [[ -d "$CONFIGS_DIR/themes" ]]; then
    mkdir -p "$HOME/.config/omarchy/themes"
    cp -rv "$CONFIGS_DIR/themes/"* "$HOME/.config/omarchy/themes/"
    log_success "Custom themes (purple-rising, q2dm1) restored."
  fi

  # Terminals
  mkdir -p "$HOME/.config/alacritty" "$HOME/.config/ghostty" "$HOME/.config/kitty" "$HOME/.config/foot"
  [[ -f "$CONFIGS_DIR/terminals/alacritty.toml" ]] && cp -v "$CONFIGS_DIR/terminals/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  [[ -f "$CONFIGS_DIR/terminals/ghostty.config" ]] && cp -v "$CONFIGS_DIR/terminals/ghostty.config" "$HOME/.config/ghostty/config"
  [[ -f "$CONFIGS_DIR/terminals/kitty.conf" ]] && cp -v "$CONFIGS_DIR/terminals/kitty.conf" "$HOME/.config/kitty/kitty.conf"
  [[ -f "$CONFIGS_DIR/terminals/foot.ini" ]] && cp -v "$CONFIGS_DIR/terminals/foot.ini" "$HOME/.config/foot/foot.ini"
  log_success "Terminal font sizes and configurations restored."

  # Chrome Flags & Desktop Launchers
  cp -v "$CONFIGS_DIR/chrome-flags.conf" "$HOME/.config/chrome-flags.conf"
  ln -sf chrome-flags.conf "$HOME/.config/google-chrome-flags.conf"
  ln -sf chrome-flags.conf "$HOME/.config/google-chrome-stable-flags.conf"
  ln -sf chrome-flags.conf "$HOME/.config/chromium-flags.conf"

  mkdir -p "$HOME/.local/bin"
  cp -v "$CONFIGS_DIR/local-bin/apple-music" "$HOME/.local/bin/apple-music"
  chmod +x "$HOME/.local/bin/apple-music"

  mkdir -p "$HOME/.local/share/applications"
  cp -v "$CONFIGS_DIR/applications/Apple Music.desktop" "$HOME/.local/share/applications/Apple Music.desktop"

  # Application Icons
  if [[ -d "$CONFIGS_DIR/icons" ]]; then
    mkdir -p "$HOME/.local/share/icons/hicolor/256x256/apps"
    cp -v "$CONFIGS_DIR/icons/"* "$HOME/.local/share/icons/hicolor/256x256/apps/" 2>/dev/null || true
    command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
  fi
  log_success "Chrome flags, icons, and Apple Music isolated launcher restored."

  # Bash additions
  if [[ -f "$CONFIGS_DIR/bash/bashrc-additions.sh" ]]; then
    if ! grep -q "update-plugins" "$HOME/.bashrc" 2>/dev/null; then
      echo "" >> "$HOME/.bashrc"
      cat "$CONFIGS_DIR/bash/bashrc-additions.sh" >> "$HOME/.bashrc"
      log_success "Appended custom aliases to ~/.bashrc."
    fi
  fi

  # Reload desktop
  command -v hyprctl >/dev/null && hyprctl reload || true
  command -v omarchy >/dev/null && omarchy restart shell || true
}

restore_plugins() {
  log_info "Synchronizing Omarchy Shell Plugins..."
  local PLUGINS_REPO_DIR="$HOME/Work/omarchy-plugins"

  if [[ ! -d "$PLUGINS_REPO_DIR" ]]; then
    mkdir -p "$HOME/Work"
    log_info "Cloning bchurch95/omarchy-plugins repository..."
    git clone https://github.com/bchurch95/omarchy-plugins.git "$PLUGINS_REPO_DIR"
  else
    log_info "Updating bchurch95/omarchy-plugins repository..."
    git -C "$PLUGINS_REPO_DIR" pull --rebase || true
  fi

  if [[ -f "$PLUGINS_REPO_DIR/sync.sh" ]]; then
    bash "$PLUGINS_REPO_DIR/sync.sh" install
    log_success "All plugins installed and synchronized from plugins.json."
  else
    log_warn "sync.sh not found in $PLUGINS_REPO_DIR."
  fi
}

# Main Execution
ACTION="${1:-}"

case "$ACTION" in
  --all)
    restore_user_configs
    restore_plugins
    log_success "Complete desktop preferences restoration finished!"
    ;;
  --configs)
    restore_user_configs
    ;;
  --plugins)
    restore_plugins
    ;;
  --help|-h)
    usage
    ;;
  "")
    echo "${BOLD}Omarchy Preferences Restore Wizard${RESET}"
    echo "1) Restore All (User Configs, Themes, Terminals & Shell Plugins)"
    echo "2) Restore User Configs Only (~/.config, ~/.local)"
    echo "3) Restore & Synchronize Shell Plugins"
    echo "q) Quit"
    read -rp "Select option [1-3/q]: " choice
    case "$choice" in
      1)
        restore_user_configs
        restore_plugins
        log_success "All components successfully restored!"
        ;;
      2) restore_user_configs ;;
      3) restore_plugins ;;
      *) echo "Exiting without changes." ;;
    esac
    ;;
  *)
    echo "Unknown option: $ACTION" >&2
    usage
    exit 1
    ;;
esac
