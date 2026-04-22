local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Gruvbox Dark (Gogh)"
config.font_size = 12.5
config.window_background_opacity = 0.95
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"

return config
