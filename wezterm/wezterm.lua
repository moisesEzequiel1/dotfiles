local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Shell default: PowerShell 7
config.default_prog = { "pwsh.exe" }

-- Fuente
config.font = wezterm.font("Cascadia Code")
config.font_size = 11.0

-- Tema
config.color_scheme = nil

config.hide_tab_bar_if_only_one_tab = true

return config
