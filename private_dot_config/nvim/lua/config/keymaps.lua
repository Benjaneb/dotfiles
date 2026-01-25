-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Preview typst file
map('n', '<leader>p', function ()
    local filename = vim.fn.expand('%')
    local pdf = vim.fn.expand('%:r') .. '.pdf'
    local noout = '&>/dev/null'
    os.execute(string.format('typst watch "%s" %s &', filename, noout))
    os.execute(string.format('xdg-open "%s" %s & disown', pdf, noout))
end)
