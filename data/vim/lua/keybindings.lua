
vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<Leader>f',  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })

