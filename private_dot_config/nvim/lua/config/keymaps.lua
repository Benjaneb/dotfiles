-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Preview typst file
map('n', '<leader>p', function ()
    local filename = vim.fn.expand('%')
    local extension = vim.fn.expand('%:e')
    if extension == 'typ' then
        vim.fn.jobstart({ 'typst', 'watch', filename })
        local pdf = vim.fn.expand('%:r') .. '.pdf'
        vim.fn.jobstart({ 'xdg-open', pdf })
    elseif extension == 'tex' then
        vim.fn.jobstart({ 'latexmk', '-pdf', '-pvc', '-interaction=batchmode', filename })
    end
end)
