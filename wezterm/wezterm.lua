local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("Fantasque Sans Mono")
config.line_height = 1.3
config.font_size = 20

-- Appearance
config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Color Scheme
config.color_scheme = "Gruvbox dark, medium (base16)"

return config
