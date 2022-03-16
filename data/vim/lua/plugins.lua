
--------------------------------------------------------------------------------
-- Bootstrap                                                                  --
--------------------------------------------------------------------------------
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

--------------------------------------------------------------------------------
-- Plugins                                                                    --
--------------------------------------------------------------------------------
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
