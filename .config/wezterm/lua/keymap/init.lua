local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.disable_default_key_bindings = true
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
