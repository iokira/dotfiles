local wezterm = require("wezterm")
local config  ={}

config.font = wezterm.font "JetBrainsMono Nerd Font"
config.font_size = 15
wezterm.on("toggle-font-size", function (window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.font_size then
        overrides.font_size = 20
    else
        overrides.font_size = nil
    end
    window:set_config_overrides(overrides)
end)

return config
