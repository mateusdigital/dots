--------------------------------------------------------------------------------
-- Bootstrap                                                                  --
--------------------------------------------------------------------------------
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { 
   command = 'source <afile> | PackerCompile', 
   group   = packer_group, pattern = 'init.lua' 
})


--------------------------------------------------------------------------------
-- Plugins                                                                    --
--------------------------------------------------------------------------------
require('packer').startup(function(use)
    -- Packer
    use { "wbthomason/packer.nvim" }
    -- Themes
    use { "tomasiser/vim-code-dark" }
    -- Telescope
    use { "nvim-lua/plenary.nvim" }
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    -- UI
    use {'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps' }
    use { "kyazdani42/nvim-web-devicons" }
    use { 'romgrk/barbar.nvim', requires = {"kyazdani42/nvim-web-devicons"} }
    -- use { 'nvim-lualine/lualine.nvim' }
    -- Code Utils
    use { "junegunn/vim-easy-align" }
    use { "norcalli/nvim-colorizer.lua" }
    use { "lukas-reineke/indent-blankline.nvim" }
    -- Language Providers / Debug
    -- use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate all" }
    -- use { 'neoclide/coc.nvim', branch = 'release'}
end)


require("plugin_config.barbar");
