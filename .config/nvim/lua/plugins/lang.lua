return {
    -- nvim-treesitter
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
            require("nvim-treesitter.configs").setup({
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
                    "tsx",
                    "vimdoc",
                },
            })
        end,
    },

    -- nvim-bqf
    {
        "kevinhwang91/nvim-bqf",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
    },

    -- rust.vim
    {
        "rust-lang/rust.vim",
        lazy = true,
        ft = { "rust" },
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    -- satysfi.vim
    {
        "qnighy/satysfi.vim",
        lazy = true,
        ft = { "satyh", "saty", "satyg" },
    },

    -- copilot.vim
    {
        "github/copilot.vim",
        lazy = true,
        event = { "InsertEnter" },
    },
}
