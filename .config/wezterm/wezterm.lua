local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- launch target
local mac = wezterm.target_triple:find("darwin")
config.default_prog = { 'tmux' }
if mac then
    config.default_prog = { '/opt/homebrew/bin/tmux' }
else
    config.default_prog = { 'tmux' }
end

-- font
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

-- window
config.window_background_opacity = 0.85
local mux = wezterm.mux
wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
end)
wezterm.on("toggle-opacity", function(window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 1
    else
        overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
end)


-- tab bar
config.hide_tab_bar_if_only_one_tab = true

-- key assignments
config.leader = {
    key = "k",
    mods = "CTRL",
    timeout_milliseconds = 1000,
}
config.keys = {
    {
        key = "f",
        mods = "LEADER",
        action = act.ToggleFullScreen,
    },
    {
        key = "c",
        mods = "LEADER",
        action = act.ActivateCopyMode,
    },
    {
        key = "Backspace",
        mods = "CTRL",
        action = act.SendKey {
            key = "w",
            mods = "CTRL",
        }
    },
    {
        key = ' ',
        mods = "LEADER",
        action = act.QuickSelect,
    },
    {
        key = "o",
        mods = "LEADER",
        action = act.EmitEvent "toggle-opacity",
    },
    {
        key = "+",
        mods = "LEADER",
        action = act.EmitEvent "toggle-font-size"
    }
}

return config
