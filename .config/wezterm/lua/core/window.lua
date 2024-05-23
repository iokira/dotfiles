local wezterm = require("wezterm")
local config = {}

config.window_background_opacity = 1
local mux = wezterm.mux
wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window({})
    window:gui_window():maximize()
end)
wezterm.on("update-right-status", function(window, pane)
    local leader = ""
    if window:leader_is_active() then
        leader = "LEADER"
    end
    window:set_right_status(wezterm.format {
        { Foreground = { Color = "orange" } },
        { Background = { Color = "#000000" } },
        { Text = leader },
    })
end)
function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end
wezterm.on(
    "format-tab-title",
    function(tab, tabs, panes, config, hover, max_width)
        local pane = tab.active_pane
        local title = basename(pane.foreground_process_name) .. " " .. tab.tab_index + 1
        if pane.is_zoomed then
            title = basename(pane.foreground_process_name) .. " " .. tab.tab_index + 1 .. " Z"
        end
        return {
            { Text = " " .. title .. " " },
        }
    end
)
config.tab_bar_at_bottom = true
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.show_new_tab_button_in_tab_bar = false

return config
