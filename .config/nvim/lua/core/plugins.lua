local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
    -- nightfox
    -- A highly customizable theme for vim and neovim with support for lsp, treesitter and a variety of plugins.
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        event = "VimEnter",
        config = function ()
            require("nightfox").setup {
                transparent = true,
            }
            vim.cmd.colorscheme "carbonfox"
        end
    },

    -- lualine
    -- A blazing fast and easy to configure Neovim statusline written in Lua.
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
                        {
                            "macro_recording",
                            fmt = show_macro_recording,
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
    },

    -- gitsigns
    -- Super fast git decorations implemented purely in Lua.
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        init = function ()
            vim.keymap.set("n", "]c", function ()
                if vim.wo.diff then
                    vim.cmd.normal({"]c", bang = true})
                else
                    require("gitsigns").nav_hunk("next")
                end
            end)
            vim.keymap.set("n", "[c", function ()
                if vim.wo.diff then
                    vim.cmd.normal({"[c", bang = true})
                else
                    require("gitsigns").nav_hunk("prev")
                end
            end)
        end,
        config = function()
            require"gitsigns".setup {}
        end,
    },

    -- fidget.nvim
    -- Extensible UI for Neovim notifications and LSP progress messages.
    {
        "j-hui/fidget.nvim",
        lazy = true,
        event = { "LspAttach" },
        config = function ()
            require("fidget").setup()
        end
    },

    -- hlchunk.nvim
    -- This is the lua implementation of nvim-hlchunk, you can use this neovim plugin to highlight your indent line and the current chunk you cursor stayed
    {
        "shellRaining/hlchunk.nvim",
        lazy = true,
        event = { "BufReadPre", "BufAdd", "BufNewFile" },
        config = function ()
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                },
                indent = {
                    enable = true,
                }
            }
        end
    },

    -- nvim-colorizer
    -- The fastest Neovim colorizer
    {
        "norcalli/nvim-colorizer.lua",
        lazy = true,
        event = { "BufReadPre", "BufAdd", "BufNewFile" },
        config = function ()
            require("colorizer").setup()
        end
    },

    -- hop.nvim
    -- Hop is an EasyMotion-like plugin allowing you to jump anywhere in a document with as few as keystrokes as possible.
    -- `<Leader>w` - Hop word
    {
        "smoka7/hop.nvim",
        lazy = true,
        init = function()
            vim.keymap.set({ "n", "v" }, "<Leader>w", function()
                require("hop").hint_words()
            end, { remap = false })
        end,
        config = function()
            require"hop".setup()
        end,
    },

    -- Comment.nvim
    -- Smart adn Powerful commenting plugin for neovim
    -- `gcc` - Toggles the current line using linewise comment
    -- `gc` - Toggles the region using linewise comment
    {
        "numToStr/Comment.nvim",
        lazy = true,
        init = function ()
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
    },

    -- telescope.nvim
    -- Gaze deeply into unknown regions using the power of the moon.
    -- `<Leader>s` - Find files
    -- `<Leader>g` - Git ls-files
    -- `<Leader>l` - Live grep
    -- `<Leader>b` - Buffers
    -- `<Leader>d` - Diagnostics
    -- `<Leader>o` - Lists previously open files
    -- `<Leader>f` - File browser
    -- `<Leader>m` - Lists vim marks and their value, jumps to the mark on `<cr>`
    -- `:Help` - Help tags
    -- `:History` - Noice history
    -- `:Commits` - Git commits
    -- `:Status` - Git status
    -- `:Commands` - Commands
    -- `:CommandHistory` - Command history
    -- `:SearchHistory` - Search history
    -- `:JumpList` - Vim's jumplist
    -- `:Reg` - :reg
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "kyazdani42/nvim-web-devicons" },
        },
        init = function()
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
            vim.keymap.set("n", "<Leader>m", function ()
                require("telescope.builtin").marks()
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
            vim.keymap.set("n", "q:", function ()
                require("telescope.builtin").command_history()
            end)
            vim.api.nvim_create_user_command("SearchHistory", function ()
                require("telescope.builtin").search_history()
            end, { desc = "Lists searches that were excuted recently, and reruns them on `<cr>`" })
            vim.api.nvim_create_user_command("JumpList", function ()
                require("telescope.builtin").jumplist()
            end, { desc = "Lists items from Vim's jumplist, jumps to location on `<cr>`" })
            vim.api.nvim_create_user_command("Reg", function ()
                require("telescope.builtin").registers()
            end, { desc = "Lists vim registers, pastes the contents of the register on `<cr>`" })
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
                    file_ignore_patterns = {
                        "^.git/",
                        "^node_modules/",
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "-uu",
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
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    }
                },
            }
        end,
    },

    -- nvim-treesitter
    -- Treesitter configuratios and abstraction layer for Neovim.
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        build = function()
            if #vim.api.nvim_list_uis() ~= 0 then
                vim.api.nvim_command([[TSUpdate]])
            end
        end,
        event = "BufReadPre",
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
    },

    -- nvim-bqf
    -- The goal of nvim-bqf is to make Neovim's quickfix window better
    {
        "kevinhwang91/nvim-bqf",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
    },

    -- nvim-autopairs
    -- A super powerful autopair plugin for Neovim that supports multiple characters.
    {
        "windwp/nvim-autopairs",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require"nvim-autopairs".setup {}
        end,
    },

    -- nvim-cmp
    -- A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
            { "onsails/lspkind.nvim" },
            { "L3MON4D3/LuaSnip" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "ray-x/cmp-treesitter" },
        },
        config = function()
            vim.opt.completeopt = "menu,menuone,noselect"
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
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
                    ["<C-k>"] = cmp.mapping(function (fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "vsnip" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "treesitter " },
                }, {
                    { name = "buffer" },
                    { name = "luasnip" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
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
            local snip = luasnip.snippet
            local text = luasnip.text_node
            local insert = luasnip.insert_node
            luasnip.add_snippets(nil, {
                cpp = {
                    snip({
                        trig = 'std',
                    }, {
                            text({'#include <bits/stdc++.h>', 'using namespace std;', ''}),
                            insert(0),
                        }),
                },
            })
        end,
    },

    -- lspconfig
    -- Quickstart configs for Nvim LSP
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        dependencies = {
            { "williamboman/mason.nvim" },
            {
                "williamboman/mason-lspconfig.nvim",
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
                    mason.setup({
                        ui = {
                            border = "single",
                        }
                    })
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
            },
            { "hrsh7th/cmp-nvim-lsp" },
        }
    },

    -- nvim-navic
    -- A sinple statusline/winbar component that uses LSP to show your current code context.
    -- Named after the Indian setellite nevigation system.
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
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
    },

    -- nvim-navbuddy
    -- A simple popup display that provides breadcrumbs like navigation feature but in keyboard centric manner inspired by ranger file manager.
    -- `<Leader>v` - Open Navbuddy
    {
        "SmiteshP/nvim-navbuddy",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        init = function ()
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
    },

    -- noice.nvim
    -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        lazy = true,
        event = { "BufReadPre", "BufAdd", "BufNewFile" },
        dependencies = {
            { "MunifTanjim/nui.nvim" },
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
                            find = ".*lines? --.*%--"
                        },
                        opts = { skip = true }
                    }
                }
            }
        end,
    },

    -- rust.vim
    -- This is a Vim plugin that provides Rust file detection, syntax highlighting, formatting, Syntastic intefration, and more.
    {
        "rust-lang/rust.vim",
        lazy = true,
        ft = { "rust" },
        config = function ()
            vim.g.rustfmt_autosave = 1
        end
    },

    -- rustaceanvim
    -- Supercharge your Rust experience in Neovim!
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        lazy = false,
    },

    -- satysfi.vim
    -- This is a Vim plugin which provides syntax highlighting and indentation fuctionally for SATySFi programs/documents.
    {
        "qnighy/satysfi.vim",
        lazy = true,
        ft = { "satyh", "saty", "satyg" }
    },

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
    {
        "kylechui/nvim-surround",
        lazy = true,
        event = "InsertEnter",
        config = function ()
            require("nvim-surround").setup()
        end
    },

    -- nvim-ts-autotag
    -- Use treesitter to autoclose and autorename html tag
    {
        "windwp/nvim-ts-autotag",
        lazy = true,
        event = "InsertEnter",
        config = function ()
            require("nvim-ts-autotag").setup()
        end
    },

    -- lspsaga.nvim
    -- improve lsp experience in neovim
    {
        "nvimdev/lspsaga.nvim",
        lazy = true,
        event = { "LspAttach" },
        dependencies = { "neovim/nvim-lspconfig" },
        init = function()
            vim.keymap.set("n", "gr", function()
                require('lspsaga.rename'):lsp_rename()
            end, { silent = true })
            vim.keymap.set("n", "K", function()
                require("lspsaga.hover"):render_hover_doc()
            end, { silent = true })
            vim.keymap.set("n", "ge", function()
                require('lspsaga.diagnostic.show'):show_diagnostics({ line = true })
            end, { silent = true })
            vim.keymap.set("n", "gx", function()
                require('lspsaga.codeaction'):code_action()
            end, {silent = true})
        end,
        config = function()
            local status, saga = pcall(require, "lspsaga")
            if (not status) then return end
            saga.setup()
        end,
    },

    -- copilot.vim
    -- GitHub Copilot for Vim and Neovim
    {
        "github/copilot.vim",
        lazy = true,
        event = { "InsertEnter", "CursorHoldI", "CursorHold" },
    },

    -- CopilotChat.nvim
    -- Copilot Chat for Neovim
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = true,
        event = { "CursorHoldI", "CursorHold" },
        branch = "canary",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            debug = true,
        }
    },
}
