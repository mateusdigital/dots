
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function n(lhs, rhs)
    map("n", lhs, rhs)
end


-- Remap space as leader key. Leader key is a special key that will allow us to make some additional keybindings. I"m using a spacebar, but you can use whatever you"d wish. We"ll use it (for example) for searching and changing files (by pressing spacebar, then `s` and then `f`).
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

n("<leader>r", ":luafile %<cr>")
n("<tab>", ".")

vim.cmd [[
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
]]

