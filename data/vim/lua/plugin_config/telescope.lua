require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

local _m = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

_m("<leader>f", [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
