
-- Remap space as leader key. Leader key is a special key that will allow us to make some additional keybindings. I"m using a spacebar, but you can use whatever you"d wish. We"ll use it (for example) for searching and changing files (by pressing spacebar, then `s` and then `f`).
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap('n', "<leader>r", ":luafile %<cr>", { noremap = true, silent = true })
