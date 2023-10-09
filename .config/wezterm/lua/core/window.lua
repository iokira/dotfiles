local wezterm = require("wezterm")
local config = {}

config.window_background_opacity = 1
local mux = wezterm.mux
wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window({})
    window:gui_window():toggle_fullscreen()
end)
wezterm.on("toggle-opacity", function(window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 0.85
    else
        overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
end)
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true

return config
