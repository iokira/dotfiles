local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.leader = {
    key = "j",
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
        key = " ",
        mods = "LEADER",
        action = act.QuickSelect,
    },
    {
        key = "v",
        mods = "LEADER",
        action = act.SplitPane({
            direction = "Right",
            size = { Percent = 50 },
        }),
    },
    {
        key = "s",
        mods = "LEADER",
        action = act.SplitPane({
            direction = "Down",
            size = { Percent = 50 },
        }),
    },
    {
        key = "K",
        mods = "LEADER",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "H",
        mods = "LEADER",
        action = act.ActivateTabRelative(-1),
    },
    {
        key = "L",
        mods = "LEADER",
        action = act.ActivateTabRelative(1),
    },
    {
        key = "h",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "l",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Right"),
    },
    {
        key = "k",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "j",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "LeftArrow",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Left", 5 }),
    },
    {
        key = "DownArrow",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Down", 5 }),
    },
    {
        key = "UpArrow",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Up", 5 }),
    },
    {
        key = "RightArrow",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Right", 5 }),
    },
    {
        key = "z",
        mods = "LEADER",
        action = act.TogglePaneZoomState,
    },
    {
        key = "o",
        mods = "LEADER",
        action = act.EmitEvent("toggle-opacity"),
    },
    {
        key = "+",
        mods = "LEADER",
        action = act.EmitEvent("toggle-font-size"),
    },
}

for i = 1, 8 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = act.ActivateTab(i - 1),
    })
end

return config
