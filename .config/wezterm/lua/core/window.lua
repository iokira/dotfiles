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
wezterm.on("update-right-status", function(window, pane)
    local leader = ''
    if window:leader_is_active() then
        leader = "LEADER"
    end
    window:set_right_status(leader)
end)
function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end
wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local pane = tab.active_pane
        local title = basename(pane.foreground_process_name) .. ' ' .. tab.tab_index
        if pane.is_zoomed then
            title = basename(pane.foreground_process_name) .. ' ' .. tab.tab_index .. ' Z'
        end
        return {
            { Text = ' ' .. title .. ' ' },
        }
    end
)
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true

return config
