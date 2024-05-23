local global = require('core.global')
local vim = vim

local createdir = function()
    local data_dir = {
        global.cache_dir .. 'backup',
        global.cache_dir .. 'session',
        global.cache_dir .. 'swap',
        global.cache_dir .. 'tags',
        global.cache_dir .. 'undo',
    }
    if vim.fn.isdirectory(global.cache_dir) == 0 then
        os.execute('mkdir -p ' .. global.cache_dir)
        for _, v in pairs(data_dir) do
            if vim.fn.isdirectory(v) == 0 then
                os.execute('mkdir -p ' .. v)
            end
        end
    end
end

local disable_distribution_plugins = function()
    vim.g.did_install_default_menus = 1
    vim.g.did_install_syntax_menu = 1
    vim.g.loaded_syntax_completion = 1
    vim.g.loaded_spellfile_plugin = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_sql_completion = 1
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

local leader_map = function ()
    vim.g.mapleader = ' '
    vim.api.nvim_set_keymap('n', ' ', '', { noremap = true })
    vim.api.nvim_set_keymap('x', ' ', '', { noremap = true })
end

local load_core = function()
    createdir()
    disable_distribution_plugins()
    leader_map()
    require("core.plugins")
    require("core.options")
    require("keymap")
    require("modules")
end

load_core()
