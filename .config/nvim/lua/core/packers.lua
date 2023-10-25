local packer = nil
local function init()
    if packer == nil then
        packer = require("packer")
        packer.init({
            display = {
                open_fn = require("packer.util").float
            }
        })
    end

    local use = packer.use
    packer.reset()

    -- packer.nvim
    -- A use-package inspired plugin manager for Neovim.
    use {
        "wbthomason/packer.nvim",
        module = { "packer" },
    }

    -- tokyonight.nvim
    -- A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins.
    use {
        "folke/tokyonight.nvim",
        event = { "VimEnter" },
        config = function()
            require("tokyonight").setup({
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                }
            })
            vim.opt.background = "dark"
            vim.cmd.colorscheme "tokyonight"
        end
    }

    -- lualine
    -- A blazing fast and easy to configure Neovim statusline written in Lua.
    use {
        "nvim-lualine/lualine.nvim",
        event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
        requires = { "kyazdani42/nvim-web-devicons", module = { "nvim-web-devicons" } },
        config = function()
            -- winbar
            require("nvim-navic")
            require"lualine".setup {
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {
                        "branch",
                        "diff",
                        {
                            "diagnostics",
                            symbols = {error = " ", warn = " ", info = " ", hint = "H "}
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
                        "encoding",
                        "fileformat",
                        "filetype",
                    }
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
            }
        end
    }

    -- hop.nvim
    -- Hop is an EasyMotion-like plugin allowing you to jump anywhere in a document with as few as keystrokes as possible.
    -- `<Leader>w` - Hop word
    use {
        "phaazon/hop.nvim",
        branch = "v2",
        module = { "hop" },
        setup = function()
            vim.keymap.set({ "n", "v" }, "<Leader>w", function()
                require("hop").hint_words()
            end, { remap = false })
        end,
        config = function()
            require"hop".setup {}
        end,
    }

    -- Comment.nvim
    -- Smart adn Powerful commenting plugin for neovim
    -- `gcc` - Toggles the current line using linewise comment
    -- `gc` - Toggles the region using linewise comment
    use {
        "numToStr/Comment.nvim",
        event = { "BufRead", "BufNewFile" },
        setup = function ()
            vim.keymap.set("n", "gc", function ()
                require("Comment.api").call("toggle.linewise", "g@")
            end, { expr = true } )
            vim.keymap.set("n", "gcc", function ()
                require("Comment.api").call("toggle.linewise.current", "g@$")
            end, { expr = true } )
        end,
        config = function ()
            require("Comment").setup {}
        end
    } -- easy comment out

    -- telescope.nvim
    -- Gaze deeply into unknown regions using the power of the moon.
    -- `<Leader>s` - Find files
    -- `<Leader>g` - Git ls-files
    -- `<Leader>l` - Live grep
    -- `<Leader>b` - Buffers
    -- `<Leader>d` - Diagnostics
    -- `<Leader>o` - Lists previously open files
    -- `<Leader>f` - File browser
    -- `:Help` - Help tags
    -- `:History` - Noice history
    -- `:Commits` - Git commits
    -- `:Status` - Git status
    -- `:Commands` - Commands
    -- `:CommandHistory` - Command history
    -- `:SearchHistory` - Search history
    -- `:JumpList` - Vim's jumplist
    use {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = {
            { "nvim-lua/plenary.nvim", opt = true },
            { "nvim-telescope/telescope-file-browser.nvim", opt = true },
            { "kyazdani42/nvim-web-devicons", opt = true },
        },
        wants = { "plenary.nvim", "telescope-file-browser.nvim", "nvim-web-devicons" },
        module = { "telescope", "telescope.builtin" },
        setup = function()
            local function telescope_buffer_dir()
                return vim.fn.expand("%:p:h")
            end
            vim.keymap.set("n", "<Leader>s",
                function()
                    require("telescope.builtin").find_files({
                        no_ignore = false,
                        hidden = true
                    })
                end)
            vim.keymap.set("n", "<Leader>g", function ()
                require("telescope.builtin").git_files()
            end)
            vim.keymap.set("n", "<Leader>l", function()
                require("telescope.builtin").live_grep()
            end)
            vim.keymap.set("n", "<Leader>b", function()
                require("telescope.builtin").buffers()
            end)
            vim.keymap.set("n", "<Leader>d", function()
                require("telescope.builtin").diagnostics()
            end)
            vim.keymap.set("n", "<Leader>o", function ()
                require("telescope.builtin").oldfiles()
            end)
            vim.keymap.set("n", "<Leader>f", function()
                require("telescope").extensions.file_browser.file_browser({
                    path = "%:p:h",
                    cwd = telescope_buffer_dir(),
                    respect_gitignore = false,
                    hidden = true,
                    grouped = true,
                    previewer = false,
                    initial_mode = "normal",
                    layout_config = { height = 40 }
                })
            end)
            vim.api.nvim_create_user_command("Help", function()
                require("telescope.builtin").help_tags()
            end, { desc = "Lists available help tags and opens a new window with the relevant help info on `<cr>`" })
            vim.api.nvim_create_user_command("History", function ()
                require("telescope").extensions.noice.noice({})
            end, { desc = "Shows the message history" })
            vim.api.nvim_create_user_command("Commits", function ()
                require("telescope.builtin").git_commits()
            end, { desc = "Lists commits for current directory with diff preview" })
            vim.api.nvim_create_user_command("Status", function ()
                require("telescope.builtin").git_status()
            end, { desc = "Lists git status for current directory" })
            vim.api.nvim_create_user_command("Commands", function ()
                require("telescope.builtin").commands()
            end, { desc = "Lists available plugin/user commands and runs them on `<cr>`" })
            vim.api.nvim_create_user_command("CommandHistory", function ()
                require("telescope.builtin").command_history()
            end, { desc = "Lists commands that were excuted recently, and reruns them on `<cr>`" })
            vim.api.nvim_create_user_command("SearchHistory", function ()
                require("telescope.builtin").search_history()
            end, { desc = "Lists searches that were excuted recently, and reruns them on `<cr>`" })
            vim.api.nvim_create_user_command("JumpList", function ()
                require("telescope.builtin").jumplist()
            end, { desc = "Lists items from Vim's jumplist, jumps to location on `<cr>`" })
        end,
        config = function()
            local actions = require("telescope.actions")
            local fb_actions = require("telescope").extensions.file_browser.actions
            require("telescope").load_extension("noice")
            require("telescope").setup {
                defaults = {
                    mappings = {
                        n = {
                            ["q"] = actions.close
                        },
                    },
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
                        mappings = {
                            ["i"] = {
                                ["<C-w>"] = function() vim.cmd("normal vbd") end,
                            },
                            ["n"] = {
                                ["h"] = fb_actions.goto_parent_dir,
                                ["/"] = function()
                                    vim.cmd("startinsert")
                                end
                            },
                        },
                    },
                },
            }
        end,
    }

    -- nvim-treesitter
    -- Treesitter configuratios and abstraction layer for Neovim.
    use {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufRead", "BufNewFile" },
        run = { ":TSUpdate" },
        config = function()
            require"nvim-treesitter.configs".setup {
                autoinstall = true,
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = true,
                    disable = {},
                },
                ensure_installed = {
                    "bash",
                    "fish",
                    "lua",
                    "rust",
                },
                autotag = {
                    enable = true,
                },
            }
        end
    }

    -- nvim-autopairs
    -- A super powerful autopair plugin for Neovim that supports multiple characters.
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        module = { "nvim-autopairs" },
        config = function()
            require"nvim-autopairs".setup {}
        end,
    }

    -- gitsigns
    -- Super fast git decorations implemented purely in Lua.
    use {
        "lewis6991/gitsigns.nvim",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require"gitsigns".setup {}
        end,
    }

    -- nvim-cmp
    -- A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
    use {
        "hrsh7th/nvim-cmp",
        module = { "cmp" },
        requires = {
            { "neovim/nvim-lspconfig", event = { "InsertEnter"} },
            { "hrsh7th/cmp-buffer", event = { "InsertEnter" } },
            { "hrsh7th/cmp-path", event = { "InsertEnter", "CmdlineEnter" } },
            { "hrsh7th/cmp-cmdline", event = { "InsertEnter", "CmdlineEnter" } },
            { "hrsh7th/nvim-cmp", event = { "InsertEnter" } },
            -- For vsnip user
            { "hrsh7th/cmp-vsnip", event = { "InsertEnter" } },
            { "hrsh7th/vim-vsnip", event = { "InsertEnter" } },
            -- pictograms for neovim lsp completion items
            { "onsails/lspkind.nvim", module = { "lspkind" } },
        },
        config = function()
            vim.opt.completeopt = "menu,menuone,noselect"
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local lspkind = require("lspkind")
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-f>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "vsnip" },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    })
                }
            }
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }
                }
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                        {
                            name = "cmdline",
                            option = {
                                ignore_cmds = { "Man", "!" }
                            }
                        }
                    })
            })
        end,
    }

    -- lspconfig
    -- Quickstart configs for Nvim LSP
    use { "neovim/nvim-lspconfig", module = { "lspconfig" } }
    use { "williamboman/mason.nvim", module = { "mason" } }
    use { "hrsh7th/cmp-nvim-lsp", module = { "cmp_nvim_lsp" } }
    use {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufRead", "BufNewFile", "CmdlineEnter" },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            local navic = require("nvim-navic")
            local navbuddy = require("nvim-navbuddy")

            local on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
                navbuddy.attach(client, bufnr)
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "rust_analyzer" },
            })
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    }

    -- lspsaga.nvim
    -- improve lsp experience in neovim
    use {
        "kkharji/lspsaga.nvim",
        branch = "main",
        module = { "lspsaga" },
        requires = { "neovim/nvim-lspconfig", module = { "lspconfig" } },
        setup = function()
            vim.keymap.set("n", "gd", function()
                require("lspsaga.provider").preview_definition()
            end, { silent = true })
            vim.keymap.set("n", "gf", function()
                require("lspsaga.provider").lsp_finder()
            end, { silent = true })
            vim.keymap.set("n", "gr", function()
                require("lspsaga.rename").rename()
            end, { silent = true })
            vim.keymap.set("n", "K", function()
                require("lspsaga.hover").render_hover_doc()
            end, { silent = true })
            vim.keymap.set("n", "ge", function()
                require("lspsaga.diagnostic").show_line_diagnostics()
            end, { silent = true })
            vim.keymap.set("n", "gj", function()
                vim.diagnostic.goto_next()
            end, {silent = true})
            vim.keymap.set("n", "gk", function()
                vim.diagnostic.goto_prev()
            end, {silent = true})
            vim.keymap.set("n", "gx", function()
                require("lspsaga.codeaction").code_action()
            end, {silent = true})
            vim.keymap.set("x", "gx", function()
                require("lspsaga.codeaction").range_code_action()
            end, {silent = true})
        end,
        config = function()
            local saga = require("lspsaga")
            saga.init_lsp_saga {
                server_filetype_map = {
                    typescript = "typescript"
                }
            }
            saga.setup {
                debug = false,
                use_saga_diagnostic_sign = true,
                error_sign = "",
                warn_sign = "",
                hint_sign = "H",
                infor_sign = "",
                diagnostic_header_icon = "   ",
                code_action_icon = " ",
                code_action_prompt = {
                    enable = true,
                    sign = true,
                    sign_priority = 40,
                    virtual_text = true,
                },
                finder_definition_icon = "  ",
                finder_reference_icon = "  ",
                max_preview_lines = 10,
                finder_action_keys = {
                    open = "o",
                    vsplit = "s",
                    split = "i",
                    quit = "q",
                    scroll_down = "<C-f>",
                    scroll_up = "<C-b>",
                },
                code_action_keys = {
                    quit = "q",
                    exec = "<CR>",
                },
                rename_action_keys = {
                    quit = "<C-c>",
                    exec = "<CR>",
                },
                definition_preview_icon = "  ",
                border_style = "single",
                rename_prompt_prefix = "➤",
                rename_output_qflist = {
                    enable = false,
                    auto_open_qflist = false,
                },
                server_filetype_map = {},
                diagnostic_prefix_format = "%d. ",
                diagnostic_message_format = "%m %c",
                highlight_prefix = false,
            }
        end,
    }

    -- nvim-navic
    -- A sinple statusline/winbar component that uses LSP to show your current code context.
    -- Named after the Indian setellite nevigation system.
    use {
        "SmiteshP/nvim-navic",
        module = { "nvim-navic" },
        config = function()
            require("nvim-navic").setup {
                lsp = {
                    auto_attach = true,
                },
                icons = {
                    File          = " ",
                    Module        = " ",
                    Namespace     = "󰌗 ",
                    Package       = " ",
                    Class         = "󰌗 ",
                    Method        = "󰆧 ",
                    Property      = " ",
                    Field         = " ",
                    Constructor   = " ",
                    Enum          = "󰕘",
                    Interface     = "",
                    Function      = "󰊕 ",
                    Variable      = " ",
                    Constant      = "󰏿 ",
                    String        = "󰀬 ",
                    Number        = "󰎠 ",
                    Boolean       = "◩ ",
                    Array         = "󰅪 ",
                    Object        = "󰅩 ",
                    Key           = "󰌋 ",
                    Null          = "󰟢 ",
                    EnumMember    = " ",
                    Struct        = "󰌗 ",
                    Event         = " ",
                    Operator      = "󰆕 ",
                    TypeParameter = " ",
                },
            }
        end
    }

    -- nvim-navbuddy
    -- A simple popup display that provides breadcrumbs like navigation feature but in keyboard centric manner inspired by ranger file manager.
    -- `<Leader>v` - Open Navbuddy
    use {
        "SmiteshP/nvim-navbuddy",
        module = { "nvim-navbuddy" },
        setup = function ()
            vim.keymap.set("n", "<Leader>v", function ()
                require("nvim-navbuddy").open()
            end)
        end,
        config = function ()
            require("nvim-navbuddy").setup({
                window = {
                    size = { height = "40%", width = "100%" },
                    position = { row = "96%", col = "50%" },
                },
            })
        end
    }

    -- noice.nvim
    -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    use {
        "folke/noice.nvim",
        event = { "VimEnter", "BufRead", "BufNewFile" },
        module = { "noice" },
        requires = {
            { "MunifTanjim/nui.nvim", module = { "nui" } },
        },
        config = function ()
            require("noice").setup {
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
                        }
                    }
                },
                routes = {
                    {
                        filter = {
                            find = ".*lines --.*%--"
                        },
                        opts = { skip = true }
                    }
                }
            }
        end,
    }

    -- rust.vim
    -- This is a Vim plugin that provides Rust file detection, syntax highlighting, formatting, Syntastic intefration, and more.
    use {
        "rust-lang/rust.vim",
        ft = { "rust" },
        config = function ()
            vim.g.rustfmt_autosave = 1
        end
    }

    -- satysfi.vim
    -- This is a Vim plugin which provides syntax highlighting and indentation fuctionally for SATySFi programs/documents.
    use {
        "qnighy/satysfi.vim",
        ft = { "satyh", "saty", "satyg" }
    }

    -- nvim-surround
    -- Add/change/delete surrounding delimiter pairs with ease. Written with LOVE in Lua.
    --     Old text                    Command         New text
    -- --------------------------------------------------------------------------------
    --     surr*ound_words             ysiw)           (surround_words)
    --     *make strings               ys$"            "make strings"
    --     [delete ar*ound me!]        ds]             delete around me!
    --     remove <b>HTML t*ags</b>    dst             remove HTML tags
    --     'change quot*es'            cs'"            "change quotes"
    --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    --     delete(functi*on calls)     dsf             function calls
    use {
        "kylechui/nvim-surround",
        tag = "*",
        event = { "BufRead", "BufNewFile" },
        config = function ()
            require("nvim-surround").setup()
        end
    }

    -- nvim-colorizer
    -- The fastest Neovim colorizer
    use {
        "norcalli/nvim-colorizer.lua",
        event = { "BufRead", "BufNewFile" },
        config = function ()
            require("colorizer").setup()
        end
    }

end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins
