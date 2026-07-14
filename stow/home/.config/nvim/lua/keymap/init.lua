---- move

vim.keymap.set("n", "<C-Up>", '"zdd<Up>"zP')
vim.keymap.set("n", "<C-Down>", '"zdd"zp')
vim.keymap.set("v", "<C-Up>", '"zx<Up>"zP`[V`]')
vim.keymap.set("v", "<C-Down>", '"zx"zp`[V`]')

---- window

vim.keymap.set("n", "te", ":tabedit<CR>", { silent = true })
vim.keymap.set("n", "tc", ":tabclose<CR>", { silent = true })
vim.keymap.set("n", "ss", ":split<CR>", { silent = true })
vim.keymap.set("n", "sv", ":vsplit<CR>", { silent = true })
vim.keymap.set("n", "sh", "<C-w>h", { silent = true })
vim.keymap.set("n", "sj", "<C-w>j", { silent = true })
vim.keymap.set("n", "sk", "<C-w>k", { silent = true })
vim.keymap.set("n", "sl", "<C-w>l", { silent = true })
vim.keymap.set("n", "t!", "<C-w>T", { silent = true })

---- terminal mode Esc

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

---- disable mouse clicks

vim.keymap.set({ "n", "v" }, "<LeftMouse>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<2-LeftMouse>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<3-LeftMouse>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<4-LeftMouse>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<RightMouse>", "<Nop>")

---- lsp

vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
end, { desc = "Show hover" })
vim.keymap.set("n", "gr", function()
    vim.lsp.buf.rename()
end, { desc = "Rename" })
vim.keymap.set("n", "ge", function()
    vim.diagnostic.open_float()
end, { desc = "Open diagnostic float" })
vim.keymap.set("n", "gj", function()
    vim.diagnostic.goto_next()
end, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "gk", function()
    vim.diagnostic.goto_prev()
end, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
end, { desc = "Go to definition" })
vim.keymap.set("n", "gf", function()
    vim.lsp.buf.references()
end, { desc = "Go to references" })
