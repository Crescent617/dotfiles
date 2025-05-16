-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
-- config.color_scheme = "Dracula"
config.color_scheme = "Dracula (Official)"

config.font = wezterm.font "CaskaydiaCove NF"
-- config.hide_tab_bar_if_only_one_tab = true
config.default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" }

config.window_background_opacity = 0.9
config.window_decorations = "NONE"
config.initial_rows = 40
config.initial_cols = 120

-- use Alt+Number to switch between tabs
config.keys = {
  { key = "1", mods = "ALT", action = wezterm.action { ActivateTab = 0 } },
  { key = "2", mods = "ALT", action = wezterm.action { ActivateTab = 1 } },
  { key = "3", mods = "ALT", action = wezterm.action { ActivateTab = 2 } },
  { key = "4", mods = "ALT", action = wezterm.action { ActivateTab = 3 } },
  { key = "5", mods = "ALT", action = wezterm.action { ActivateTab = 4 } },
  { key = "6", mods = "ALT", action = wezterm.action { ActivateTab = 5 } },
  { key = "7", mods = "ALT", action = wezterm.action { ActivateTab = 6 } },
  { key = "8", mods = "ALT", action = wezterm.action { ActivateTab = 7 } },
  { key = "9", mods = "ALT", action = wezterm.action { ActivateTab = 8 } },
}

-- and finally, return the configuration to wezterm
return config
