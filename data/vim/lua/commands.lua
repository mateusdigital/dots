vim.cmd [[autocmd BufWritePre * %s/\s\+$//e ]]
vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile PackerSync
  augroup end
]],
  false
)

