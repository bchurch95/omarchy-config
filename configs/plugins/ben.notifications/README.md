# My Notifications (`ben.notifications`)

Customized notification service plugin for the [Omarchy](https://github.com/omarchy/omarchy) desktop shell on Hyprland.

Cloned from `omarchy.notifications` with quality-of-life enhancements for presentation setups and desktop usability.

## Features

- **Direct Dismiss Button (✕):** Adds a dedicated close button to the top-right corner of notification popup cards. Allows closing/dismissing toasts immediately without clicking into or activating the notification. Includes hover effects and urgent color accenting.
- **Virtual / Presentation Display Suppression:** Automatically suppresses notification popup banners on headless or virtual displays (`VIRTUAL-*`, `HEADLESS-*`). Toasts remain visible on primary physical displays, keeping presentation slides and mirrored streams clean and uninterrupted.
- **Full Compatibility:** Retains standard D-Bus notification daemon protocol support (`org.freedesktop.Notifications`), DND (Do Not Disturb), sound effects, action buttons, and notification history.

## Installation

Clone into your Omarchy plugins directory:

```bash
git clone https://github.com/bchurch95/omarchy-notifications.git ~/.config/omarchy/plugins/ben.notifications
```

Enable the plugin in `~/.config/omarchy/shell.json`:

```json
{
  "notifications": "ben.notifications"
}
```

Restart the shell to load the service:

```bash
omarchy restart shell
```
