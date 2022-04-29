local map  = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Go-to previous/next - opt+n | opt+m (like ctrl+tab)
map('n', '<A-n>', ':BufferPrevious<CR>', opts)
map('n', '<A-m>', ':BufferNext<CR>',     opts)

-- Re-order to previous/next - opt+shift+n | opt+shift+n
map('n', '<A-N>', ':BufferMovePrevious<CR>', opts)
map('n', '<A-M>', ':BufferMoveNext<CR>',     opts)

-- Close buffer -- opt+shift+a
map('n', '<A-X>', ':BufferClose<CR>', opts)

-- Close commands
--                 :BufferCloseAllButCurrent<CR>
--                 :BufferCloseBuffersLeft<CR>
--                 :BufferCloseBuffersRight<CR>

