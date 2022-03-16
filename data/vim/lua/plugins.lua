vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer
  use 'wbthomason/packer.nvim'
  -- Themes
  use "tomasiser/vim-code-dark"
  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-lua/plenary.nvim"
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
end);
