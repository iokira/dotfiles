local MODULE_NAME = "myintro"

local vim = vim

local intro = {
    text = {
        "███▄▄▄▄       ▄████████   ▄██████▄    ▄█    █▄    ▄█     ▄▄▄▄███▄▄▄▄  ",
        "███▀▀▀██▄    ███    ███  ███    ███  ███    ███  ███   ▄██▀▀▀███▀▀▀██▄",
        "███   ███    ███    █▀   ███    ███  ███    ███  ███▌  ███   ███   ███",
        "███   ███   ▄███▄▄▄      ███    ███  ███    ███  ███▌  ███   ███   ███",
        "███   ███  ▀▀███▀▀▀      ███    ███  ███    ███  ███▌  ███   ███   ███",
        "███   ███    ███    █▄   ███    ███  ███    ███  ███   ███   ███   ███",
        "███   ███    ███    ███  ███    ███  ███    ███  ███   ███   ███   ███",
        " ▀█   █▀     ██████████   ▀██████▀    ▀██████▀   █▀     ▀█   ███   █▀ ",
    },
    width = 70,
    height = 8,
    color = "#83A1F1",
}

local autocmd_group = vim.api.nvim_create_augroup(MODULE_NAME, {})
local highlight_ns_id = vim.api.nvim_create_namespace(MODULE_NAME)
local myintro_buf = -1

local function unlock_buf(buf)
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
end

local function lock_buf(buf)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

local function draw_intro(buf, logo_width, logo_height)
    local window = vim.fn.bufwinid(buf)
    local screen_width = vim.api.nvim_win_get_width(window)
    local screen_height = vim.api.nvim_win_get_height(window) - vim.opt.cmdheight:get()

    local start_col = math.floor((screen_width - logo_width) / 2)
    local start_row = math.floor((screen_height - logo_height) / 2)
    if (start_col < 0 or start_row < 0) then return end

    local top_space = {}
    for _ = 1, start_row do table.insert(top_space, "") end

    local col_offset_spaces = {}
    for _ = 1, start_col do table.insert(col_offset_spaces, " ") end
    local col_offset = table.concat(col_offset_spaces, '')

    local adjusted_logo = {}
    for _, line in ipairs(intro.text) do
        table.insert(adjusted_logo, col_offset .. line)
    end

    unlock_buf(buf)
    vim.api.nvim_buf_set_lines(buf, 1, 1, true, top_space)
    vim.api.nvim_buf_set_lines(buf, start_row, start_row, true, adjusted_logo)
    lock_buf(buf)

    vim.api.nvim_buf_set_extmark(buf, highlight_ns_id, start_row, start_col, {
        end_row = start_row + intro.height,
        hl_group = "Default"
    })
end

local function create_and_set_intro_buf(default_buf)
    local intro_buf = vim.api.nvim_create_buf("nobuflisted", "inlisted")
    vim.api.nvim_buf_set_name(intro_buf, MODULE_NAME)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = intro_buf })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = intro_buf })
    vim.api.nvim_set_option_value("filetype", "myintro", { buf = intro_buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = intro_buf })

    vim.api.nvim_set_current_buf(intro_buf)
    vim.api.nvim_buf_delete(default_buf, { force = true })

    return intro_buf
end

local function set_options()
    vim.opt_local.number = false
    vim.opt_local.list = false
    vim.opt_local.colorcolumn = "0"
end

local function redraw()
    unlock_buf(myintro_buf)
    vim.api.nvim_buf_set_lines(myintro_buf, 0, -1, true, {})
    lock_buf(myintro_buf)
    draw_intro(myintro_buf, intro.width, intro.height)
end

local function display_intro(payload)
    local is_dir = vim.fn.isdirectory(payload.file) == 1

    local default_buf = vim.api.nvim_get_current_buf()
    local default_buf_name = vim.api.nvim_buf_get_name(default_buf)
    local default_buf_filetype = vim.api.nvim_get_option_value("filetype", { buf = default_buf })
    if not is_dir and default_buf_name ~= "" and default_buf_filetype ~= MODULE_NAME then
        return
    end

    myintro_buf = create_and_set_intro_buf(default_buf)
    set_options()

    draw_intro(myintro_buf, intro.width, intro.height)

    vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
        group = autocmd_group,
        buffer = myintro_buf,
        callback = redraw
    })
end

local function setup(options)
    options = options or {}
    vim.api.nvim_set_hl(highlight_ns_id, "Default", { fg = options.color or intro.color })
    vim.api.nvim_set_hl_ns(highlight_ns_id)

    vim.api.nvim_create_autocmd("VimEnter", {
        group = autocmd_group,
        callback = display_intro,
        once = true
    })
end

setup()
