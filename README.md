# Omarchy Desktop Configuration & User Preferences

Curated user configurations, ergonomic keybindings, custom status bar widgets, themes, and automated plugin restoration for **Omarchy / Arch Linux** on **Hyprland (Wayland)**.

This repository is **hardware-agnostic** and contains only userland dotfiles and preferences (`~/.config`, `~/.local`). It does not modify `/etc` or hardware bootloader files and is safe to restore on any machine.

---

## 🚀 Quick Restore

To deploy these preferences and synchronize all shell plugins on any Omarchy installation:

```bash
git clone https://github.com/bchurch95/omarchy-config.git ~/Work/omarchy-config
cd ~/Work/omarchy-config
./restore.sh --all
```

Or run interactively:
```bash
./restore.sh
```

---

## 🪟 1. Hyprland Configuration (`~/.config/hypr/`)

### Visuals & Layout (`looknfeel.lua`)
- **Ultra-clean borderless & gapless aesthetic:** `gaps_in = 0`, `gaps_out = 0`, `border_size = 0`, `rounding = 0`, shadows disabled for maximum usable screen real estate.
- **Dynamic window rules** for Apple Music scratchpad and floating utilities.

### Keybindings & Shortcuts (`bindings.lua`)

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `SUPER + A` | **Select All** | Universal shortcut that sends `Ctrl + A` to the active application. |
| `SUPER + T` | **New Tab** | Universal shortcut that sends `Ctrl + T` in standard apps (or `Ctrl + Shift + T` in terminals). |
| `SUPER + ALT + T` | **Toggle Floating** | Toggles active window between floating and tiled layout (rebound from `Super + T`). |
| `SUPER + SHIFT + A` | **Antigravity** | Launches Antigravity agent terminal with `--dangerously-skip-permissions`. |
| `SUPER + SHIFT + M` | **Apple Music** | Launches or focuses the isolated Apple Music web app. |
| `SUPER + SHIFT + RETURN` | **Chrome (Personal)** | Opens personal Chrome profile directly, bypassing the profile picker. |
| `SUPER + CTRL + SHIFT + RETURN` | **Chrome (Work)** | Opens work Chrome profile directly, bypassing the profile picker. |
| `XF86Presentation` | **Screenshot** | Screenshot capture binding for Presentation / F-keys. |

### Input & Gestures (`input.lua`)
- **Natural (inverse) scrolling** enabled for touchpads.

---

## 🎵 2. Isolated Apple Music Web App & Chrome Media Keys

### The Problem
By default, Google Chrome enables `HardwareMediaKeyHandling` and registers an MPRIS media player on D-Bus for every media stream in browser tabs (e.g., YouTube, Twitter/X, Reddit). When running Apple Music as a web app attached to the default browser session, browsing tabs continually steal the media session and hardware media keys (Play/Pause, Next, Previous).

### The Solution
1. **Disable Chrome Browser Media Key Hijacking (`~/.config/chrome-flags.conf`)**:
   Sets `--disable-features=HardwareMediaKeyHandling` so regular browsing tabs never steal hardware media keys or register unwanted MPRIS players.
2. **Dedicated Apple Music Launcher (`~/.local/bin/apple-music`)**:
   Runs Apple Music in an isolated user-data directory (`~/.local/share/omarchy/webapps/apple-music`) with explicit `--enable-features=HardwareMediaKeyHandling,MediaSessionService` enabled.
3. **Dedicated Keybinding (`SUPER + SHIFT + M`)**:
   Quickly launch or focus Apple Music anywhere on the desktop.

---

## 📊 3. Omarchy Status Bar & Custom Modules

Curated top-bar layout (`~/.config/omarchy/shell.json`) featuring:

- **Left:** App Menu, Workspaces, Apple Music quick toggle, Media Player widget (`ben.media`).
- **Center:** Indicators, Centered Clock (`dddd h:mm AP`), Weather, Oma Cast audio streaming, System Updates.
- **Right:** Live Sysinfo CPU/RAM graph, System Tray, Omamail, Time Machine backup status, Network Shares, AirPods battery & ANC switcher, VPN switcher, AI Agents token tracker, Bluetooth, Network, Audio volume, Monitor Studio, Power menu.

### Custom QML Modules (`configs/omarchy/bar/modules/`)
- `sysinfo.qml`: Live CPU & Memory utilization graph with click-to-launch `btop`.
- `kdeconnect.qml`: Phone battery, clipboard sync, and connectivity status.

### Shell Plugins Ecosystem
Plugins are automatically synchronized with [`bchurch95/omarchy-plugins`](https://github.com/bchurch95/omarchy-plugins).

---

## 🎨 4. Custom Themes (`~/.config/omarchy/themes/`)

- **`purple-rising`**: AMOLED pure black background with deep purple accents and matching Chromium / icon styling.
- **`q2dm1`**: Quake 2 inspired AMOLED theme with custom color palette.

---

## 💻 5. Terminal Configurations

Matched typography, font sizing, and visual consistency across modern Wayland terminals:
- **Alacritty:** `~/.config/alacritty/alacritty.toml`
- **Ghostty:** `~/.config/ghostty/config`
- **Kitty:** `~/.config/kitty/kitty.conf`
- **Foot:** `~/.config/foot/foot.ini`

---

## 📁 Repository Structure

```
.
├── bootstrap.sh                             # One-liner quick curl installer
├── restore.sh                               # Interactive & CLI preference restoration tool
├── README.md                                # Documentation and keybinding reference
└── configs/
    ├── applications/                        # Desktop launchers (.desktop)
    ├── bash/                                # Custom shell aliases and functions
    ├── chrome-flags.conf                    # Chrome media keys isolation flags
    ├── hypr/                                # Hyprland bindings, looknfeel, input, autostart
    ├── icons/                               # Application icons
    ├── local-bin/                           # apple-music isolated launcher
    ├── omarchy/
    │   ├── bar/modules/                     # Custom QML bar modules (sysinfo, kdeconnect)
    │   └── shell.json                       # Curated status bar widget layout
    ├── packages/
    │   └── explicit-packages.txt            # Package manifest
    ├── plugins/                             # Local plugin sources (ben.apple-music-button)
    ├── terminals/                           # Alacritty, Ghostty, Kitty, Foot configs
    └── themes/                              # purple-rising & q2dm1 custom themes
```
