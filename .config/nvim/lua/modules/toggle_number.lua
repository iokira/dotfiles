local toggle_number = function ()
    if vim.o.number == false then
        vim.o.number = true
    elseif vim.o.relativenumber == false then
        vim.o.relativenumber = true
    else
        vim.o.number = false
        vim.o.relativenumber = false
    end
end

vim.keymap.set('n', '<Leader>n', function ()
    toggle_number()
end)
