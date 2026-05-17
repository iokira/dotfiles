return {
    -- gitsigns.nvim
    -- `]c` - Jump to next git hunk
    -- `[c` - Jump to previous git hunk
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        init = function()
            vim.keymap.set("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    require("gitsigns").nav_hunk("next")
                end
            end, { desc = "Jump to next git hunk", silent = true })
            vim.keymap.set("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    require("gitsigns").nav_hunk("prev")
                end
            end, { desc = "Jump to previous git hunk", silent = true })
        end,
        config = function()
            require("gitsigns").setup({})
        end,
    },
}
