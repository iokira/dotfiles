return {
    -- telescope.nvim
    -- `<Leader>s` - Find files
    -- `<Leader>g` - Git ls-files
    -- `<Leader>l` - Live grep
    -- `<Leader>d` - Diagnostics
    -- `<Leader>o` - Lists previously open files
    -- `<Leader>f` - File browser
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "nvim-tree/nvim-web-devicons" },
        },
        init = function()
            local function telescope_buffer_dir()
                return vim.fn.expand("%:p:h")
            end
            vim.keymap.set("n", "<Leader>s", function()
                require("telescope.builtin").find_files({
                    no_ignore = false,
                    hidden = true,
                })
            end, { desc = "Find files", silent = true })
            vim.keymap.set("n", "<Leader>g", function()
                require("telescope.builtin").git_files()
            end, { desc = "Git ls-files", silent = true })
            vim.keymap.set("n", "<Leader>l", function()
                require("telescope.builtin").live_grep()
            end, { desc = "Live grep", silent = true })
            vim.keymap.set("n", "<Leader>d", function()
                require("telescope.builtin").diagnostics()
            end, { desc = "Diagnostics", silent = true })
            vim.keymap.set("n", "<Leader>o", function()
                require("telescope.builtin").oldfiles()
            end, { desc = "Lists previously open files", silent = true })
            vim.keymap.set("n", "<Leader>f", function()
                require("telescope").extensions.file_browser.file_browser({
                    path = "%:p:h",
                    cwd = telescope_buffer_dir(),
                    respect_gitignore = false,
                    hidden = true,
                    grouped = true,
                    previewer = true,
                    initial_mode = "insert",
                    layout_config = { height = 40 },
                })
            end, { desc = "File browser", silent = true })
            vim.api.nvim_create_user_command("Buffers", function()
                require("telescope.builtin").buffers()
            end, { desc = "Buffers" })
            vim.api.nvim_create_user_command("Marks", function()
                require("telescope.builtin").marks()
            end, { desc = "Lists vim marks and their value, jumps to the mark on `<cr>`" })
            vim.api.nvim_create_user_command("Help", function()
                require("telescope.builtin").help_tags()
            end, { desc = "Lists available help tags and opens a new window with the relevant help info on `<cr>`" })
            vim.api.nvim_create_user_command("History", function()
                require("telescope").extensions.noice.noice({})
            end, { desc = "Shows the message history" })
            vim.api.nvim_create_user_command("Commits", function()
                require("telescope.builtin").git_commits()
            end, { desc = "Lists commits for current directory with diff preview" })
            vim.api.nvim_create_user_command("Status", function()
                require("telescope.builtin").git_status()
            end, { desc = "Lists git status for current directory" })
            vim.api.nvim_create_user_command("Commands", function()
                require("telescope.builtin").commands()
            end, { desc = "Lists available plugin/user commands and runs them on `<cr>`" })
            vim.api.nvim_create_user_command("CommandHistory", function()
                require("telescope.builtin").command_history()
            end, { desc = "Lists commands that were excuted recently, and reruns them on `<cr>`" })
            vim.keymap.set("n", "q:", function()
                require("telescope.builtin").command_history()
            end, { desc = "Lists commands that were excuted recently, and reruns them on `<cr>`", silent = true })
            vim.api.nvim_create_user_command("SearchHistory", function()
                require("telescope.builtin").search_history()
            end, { desc = "Lists searches that were excuted recently, and reruns them on `<cr>`" })
            vim.api.nvim_create_user_command("Jumps", function()
                require("telescope.builtin").jumplist()
            end, { desc = "Lists items from Vim's jumplist, jumps to location on `<cr>`" })
            vim.api.nvim_create_user_command("Reg", function()
                require("telescope.builtin").registers()
            end, { desc = "Lists vim registers, pastes the contents of the register on `<cr>`" })
        end,
        config = function()
            local actions = require("telescope.actions")
            local fb_actions = require("telescope").extensions.file_browser.actions
            require("telescope").load_extension("noice")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        n = {
                            ["q"] = actions.close,
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
                                ["<C-w>"] = function()
                                    vim.cmd("normal vbd")
                                end,
                            },
                            ["n"] = {
                                ["h"] = fb_actions.goto_parent_dir,
                                ["/"] = function()
                                    vim.cmd("startinsert")
                                end,
                            },
                        },
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                },
            })
        end,
    },

    -- hop.nvim
    -- `<Leader>w` - Hop word
    {
        "smoka7/hop.nvim",
        lazy = true,
        init = function()
            vim.keymap.set({ "n", "v" }, "<Leader>w", function()
                require("hop").hint_words()
            end, { desc = "Hop to word", silent = true, remap = false })
        end,
        config = function()
            require("hop").setup({
                multi_windows = true,
            })
        end,
    },

    -- nvim-navic
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        config = function()
            require("nvim-navic").setup({
                lsp = {
                    auto_attach = true,
                },
                icons = {
                    File = " ",
                    Module = " ",
                    Namespace = "󰌗 ",
                    Package = " ",
                    Class = "󰌗 ",
                    Method = "󰆧 ",
                    Property = " ",
                    Field = " ",
                    Constructor = " ",
                    Enum = "󰕘",
                    Interface = "",
                    Function = "󰊕 ",
                    Variable = " ",
                    Constant = "󰏿 ",
                    String = "󰀬 ",
                    Number = "󰎠 ",
                    Boolean = "◩ ",
                    Array = "󰅪 ",
                    Object = "󰅩 ",
                    Key = "󰌋 ",
                    Null = "󰟢 ",
                    EnumMember = " ",
                    Struct = "󰌗 ",
                    Event = " ",
                    Operator = "󰆕 ",
                    TypeParameter = " ",
                },
            })
        end,
    },

    -- nvim-navbuddy
    -- `<Leader>v` - Open Navbuddy
    {
        "SmiteshP/nvim-navbuddy",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        dependencies = {
            { "MunifTanjim/nui.nvim" },
        },
        init = function()
            vim.keymap.set("n", "<Leader>v", function()
                require("nvim-navbuddy").open()
            end, { desc = "Open Navbuddy", silent = true })
        end,
        config = function()
            require("nvim-navbuddy").setup({
                window = {
                    size = { height = "40%", width = "100%" },
                    position = { row = "96%", col = "50%" },
                },
            })
        end,
    },
}
