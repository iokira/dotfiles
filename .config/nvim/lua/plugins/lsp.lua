return {
    -- nvim-cmp
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
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            cmp.setup({
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
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "vsnip" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "treesitter" },
                }, {
                    { name = "buffer" },
                    { name = "luasnip" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
            local snip = luasnip.snippet
            local text = luasnip.text_node
            local insert = luasnip.insert_node
            luasnip.add_snippets(nil, {
                cpp = {
                    snip({
                        trig = "std",
                    }, {
                        text({ "#include <bits/stdc++.h>", "using namespace std;", "" }),
                        insert(0),
                    }),
                },
            })
        end,
    },

    -- nvim-lspconfig + mason
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
                    local navic = require("nvim-navic")
                    local navbuddy = require("nvim-navbuddy")
                    local on_attach = function(client, bufnr)
                        if client.server_capabilities.documentSymbolProvider then
                            navic.attach(client, bufnr)
                            navbuddy.attach(client, bufnr)
                        end
                    end
                    local capabilities = require("cmp_nvim_lsp").default_capabilities()
                    local ensure_installed = {
                        "lua_ls",
                        "rust_analyzer",
                        "ts_ls",
                        "biome",
                        "stylua",
                    }
                    mason.setup({
                        ui = {
                            border = "single",
                        },
                        ensure_installed = ensure_installed,
                    })
                    mason_lspconfig.setup({
                        automatic_enable = true,
                        ensure_installed = ensure_installed,
                    })
                end,
            },
            { "hrsh7th/cmp-nvim-lsp" },
        },
    },

    -- actions-preview.nvim
    -- `gx` - Code actions with preview
    {
        "aznhe21/actions-preview.nvim",
        lazy = true,
        init = function()
            vim.keymap.set({ "v", "n" }, "gx", require("actions-preview").code_actions)
        end,
    },
}
