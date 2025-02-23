local leader_map = function()
    vim.g.mapleader = " "
    vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
    vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
end

leader_map()

---- helper

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local g = vim.g

---- move

map("n", "<C-Up>", '"zdd<Up>"zP')
map("n", "<C-Down>", '"zdd"zp')
map("v", "<C-Up>", '"zx<Up>"zP`[V`]')
map("v", "<C-Down>", '"zx"zp`[V`]')

---- window

map("n", "te", ":tabedit<CR>", { silent = true })
map("n", "tc", ":tabclose<CR>", { silent = true })
map("n", "ss", ":split<CR>", { silent = true })
map("n", "sv", ":vsplit<CR>", { silent = true })
map("n", "sh", "<C-w>h", { silent = true })
map("n", "sj", "<C-w>j", { silent = true })
map("n", "sk", "<C-w>k", { silent = true })
map("n", "sl", "<C-w>l", { silent = true })
map("n", "<Left>", "<C-w><", { silent = true })
map("n", "<Down>", "<C-w>-", { silent = true })
map("n", "<Up>", "<C-w>+", { silent = true })
map("n", "<Right>", "<C-w>>", { silent = true })
map("n", "t!", "<C-w>T", { silent = true })

---- save end quit

map("n", "<Leader>z", "ZZ<CR>")
map("n", "<C-s>", ":w<CR>")

---- undo

map("n", "U", "<C-r>")

---- highlight

map("n", "<Leader><Esc>", ":<C-u>nohlsearch<CR>", { silent = true })

---- source %

map("n", "<Leader>%", ":source<Space>%<CR>")

---- Increment/decrement

map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

---- Select all

map("n", "<C-a>", "gg<S-v>G")

---- terminal mode Esc

map("t", "<Esc>", "<C-\\><C-n>")
map("t", "jk", "<C-\\><C-n>")

---- disable left mouse

map("n", "<LeftMouse>", "<Nop>")
map("v", "<LeftMouse>", "<Nop>")
map("n", "<2-LeftMouse>", "<Nop>")
map("v", "<2-LeftMouse>", "<Nop>")
map("n", "<3-LeftMouse>", "<Nop>")
map("v", "<3-LeftMouse>", "<Nop>")
map("n", "<4-LeftMouse>", "<Nop>")
map("v", "<4-LeftMouse>", "<Nop>")
map("n", "<RightMouse>", "<Nop>")
map("v", "<RightMouse>", "<Nop>")

---- insert enter

map("n", "<Leader><CR>", "o<ESC>")

---- lsp

vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
end, {
    desc = "Show hover",
})
vim.keymap.set("n", "gr", function()
    vim.lsp.buf.rename()
end, {
    desc = "Rename",
})
vim.keymap.set("n", "ge", function()
    vim.diagnostic.open_float()
end, {
    desc = "Open diagnostic float",
})
vim.keymap.set("n", "gj", function()
    vim.diagnostic.goto_next()
end, {
    desc = "Go to next diagnostic",
})
vim.keymap.set("n", "gk", function()
    vim.diagnostic.goto_prev()
end, {
    desc = "Go to previous diagnostic",
})
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
end, {
    desc = "Go to definition",
})
vim.keymap.set("n", "gf", function()
    vim.lsp.buf.references()
end, {
    desc = "Go to references",
})
