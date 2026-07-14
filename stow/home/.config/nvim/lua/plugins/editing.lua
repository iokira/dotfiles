return {
    -- nvim-autopairs
    {
        "windwp/nvim-autopairs",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- nvim-ts-autotag
    {
        "windwp/nvim-ts-autotag",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- nvim-surround
    -- Old text                    Command         New text
    -- surr*ound_words             ysiw)           (surround_words)
    -- *make strings               ys$"            "make strings"
    -- [delete ar*ound me!]        ds]             delete around me!
    -- remove <b>HTML t*ags</b>    dst             remove HTML tags
    -- 'change quot*es'            cs'"            "change quotes"
    -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    -- delete(functi*on calls)     dsf             function calls
    {
        "kylechui/nvim-surround",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- Comment.nvim
    -- `gcc` - Toggles the current line using linewise comment
    -- `gc`  - Toggles the region using linewise comment
    {
        "numToStr/Comment.nvim",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        init = function()
            vim.keymap.set("n", "gc", function()
                require("Comment.api").call("toggle.linewise", "g@")
            end, { desc = "Toggle comment on current line", silent = true, expr = true })
            vim.keymap.set("n", "gcc", function()
                require("Comment.api").call("toggle.linewise.current", "g@$")
            end, { desc = "Toggle comment on current line", silent = true, expr = true })
        end,
        config = function()
            require("Comment").setup({})
        end,
    },
}
