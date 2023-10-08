local toggle_number = function ()
    if vim.o.relativenumber == true then
        vim.o.relativenumber = false
    else
        vim.o.relativenumber = true
    end
end

vim.keymap.set('n', '<Leader>n', function ()
    toggle_number()
end)
