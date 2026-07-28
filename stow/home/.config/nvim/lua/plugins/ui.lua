return {
    -- nightfox
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        event = "VimEnter",
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = true,
                },
            })
            vim.cmd.colorscheme("carbonfox")
        end,
    },

    -- lualine
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-navic")
            local function show_macro_recording()
                local recording_register = vim.fn.reg_recording()
                if recording_register == "" then
                    return ""
                else
                    return "Recording @" .. recording_register
                end
            end
            require("lualine").setup({
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        "diff",
                        {
                            "diagnostics",
                            symbols = { error = " ", warn = " ", info = " ", hint = "H " },
                        },
                    },
                    lualine_c = {
                        "filename",
                        "navic",
                    },
                    lualine_x = {
                        {
                            require("noice").api.status.search.get,
                            cond = require("noice").api.status.search.has,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            require("noice").api.status.command.get,
                            cond = require("noice").api.status.command.has,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            "macro_recording",
                            fmt = show_macro_recording,
                            color = { fg = "#ff9e64" },
                        },
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                },
                options = {
                    globalstatus = true,
                    theme = function()
                        local colors = {
                            darkgray = "#16161d",
                            gray = "#727169",
                            innerbg = nil,
                            outerbg = "#16161D",
                            normal = "#7e9cd8",
                            insert = "#98bb6c",
                            visual = "#ffa066",
                            replace = "#e46876",
                            command = "#e6c384",
                        }
                        return {
                            inactive = {
                                a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
                                b = { fg = colors.gray, bg = colors.outerbg },
                                c = { fg = colors.gray, bg = colors.innerbg },
                            },
                            visual = {
                                a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
                                b = { fg = colors.gray, bg = colors.outerbg },
                                c = { fg = colors.gray, bg = colors.innerbg },
                            },
                            replace = {
                                a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
                                b = { fg = colors.gray, bg = colors.outerbg },
                                c = { fg = colors.gray, bg = colors.innerbg },
                            },
                            normal = {
                                a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
                                b = { fg = colors.gray, bg = colors.outerbg },
                                c = { fg = colors.gray, bg = colors.innerbg },
                            },
                            insert = {
                                a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
                                b = { fg = colors.gray, bg = colors.outerbg },
                                c = { fg = colors.gray, bg = colors.innerbg },
                            },
                            command = {
                                a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
                                b = { fg = colors.gray, bg = colors.outerbg },
                                c = { fg = colors.gray, bg = colors.innerbg },
                            },
                        }
                    end,
                },
            })
        end,
    },

    -- noice.nvim
    {
        "folke/noice.nvim",
        lazy = true,
        event = { "BufReadPre", "BufAdd", "BufNewFile" },
        dependencies = {
            { "MunifTanjim/nui.nvim" },
        },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                cmdline = {
                    format = {
                        cmdline = { icon = ">" },
                        search_down = { icon = "/⌄" },
                        search_up = { icon = "/⌃" },
                        filter = { icon = "$" },
                        lua = { icon = "☾" },
                        help = { icon = "?" },
                    },
                },
                messages = {
                    enabled = true,
                    view = "mini",
                    view_search = false,
                },
                views = {
                    mini = {
                        win_options = {
                            winblend = 0,
                        },
                    },
                },
                routes = {
                    {
                        filter = {
                            find = ".*lines? --.*%--",
                        },
                        opts = { skip = true },
                    },
                },
            })
        end,
    },

    -- hlchunk.nvim
    {
        "shellRaining/hlchunk.nvim",
        lazy = true,
        event = { "BufReadPre", "BufAdd", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                chunk = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                line_num = {
                    enable = true,
                },
            })
        end,
    },
}
