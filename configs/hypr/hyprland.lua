-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- Apple Music background dropdown / scratchpad window rules
o.window("(^.+-music\\.apple\\.com__.*$|^chrome-music\\.apple\\.com.*$|apple-music)", { tag = "-chromium-based-browser" })
o.window("(^.+-music\\.apple\\.com__.*$|^chrome-music\\.apple\\.com.*$|apple-music)", { float = true })
o.window("(^.+-music\\.apple\\.com__.*$|^chrome-music\\.apple\\.com.*$|apple-music)", { size = { 880, 560 } })
o.window("(^.+-music\\.apple\\.com__.*$|^chrome-music\\.apple\\.com.*$|apple-music)", { move = "360 36" })
o.window("(^.+-music\\.apple\\.com__.*$|^chrome-music\\.apple\\.com.*$|apple-music)", { workspace = "special:music silent" })
