return {
    -- formatter.nvim
    {
        "mhartington/formatter.nvim",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        config = function()
            local biome = function()
                local util = require("formatter.util")
                return {
                    exe = "biome",
                    args = {
                        "format",
                        "--stdin-file-path",
                        util.escape_path(util.get_current_buffer_file_path()),
                    },
                    stdin = true,
                }
            end
            local stylua = function()
                return {
                    exe = "stylua",
                    args = {
                        "--indent-type",
                        "Spaces",
                    },
                }
            end
            local shfmt = function()
                return {
                    exe = "shfmt",
                    args = {
                        "-i",
                        "4",
                    },
                    stdin = true,
                }
            end
            require("formatter").setup({
                filetype = {
                    javascript = { biome },
                    javascriptreact = { biome },
                    typescript = { biome },
                    typescriptreact = { biome },
                    lua = { stylua },
                    sh = { shfmt },
                    ["*"] = {
                        require("formatter.filetypes.any").remove_trainling_whitespace,
                    },
                },
            })
        end,
    },

    -- nvim-lint
    {
        "mfussenegger/nvim-lint",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        config = function()
            require("lint").linters_by_ft = {
                sh = { "shellcheck" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
