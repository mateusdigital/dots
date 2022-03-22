--------------------------------------------------------------------------------
-- Bootstrap                                                                  --
--------------------------------------------------------------------------------
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

vim.cmd [[packadd packer.nvim]]


--------------------------------------------------------------------------------
-- Plugins                                                                    --
--------------------------------------------------------------------------------
return require("packer").startup(function()
    -- Packer
    use { "wbthomason/packer.nvim" }
    -- Themes
    use { "tomasiser/vim-code-dark" }
    -- Telescope
    use { "nvim-telescope/telescope.nvim" }
    use { "nvim-lua/plenary.nvim" }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    -- NeoTree
    use { "kyazdani42/nvim-web-devicons" }
    use { "MunifTanjim/nui.nvim" }
    use { "nvim-neo-tree/neo-tree.nvim", branch = "v1.x" }
    -- UI
    use { "romgrk/barbar.nvim" }
    use { 'nvim-lualine/lualine.nvim' }
    -- Code Utils
    use { "junegunn/vim-easy-align" }
    use { 'norcalli/nvim-colorizer.lua' }
    -- Language Providers / Debug
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate all" }
    use { 'neoclide/coc.nvim', branch = 'release'}
end);
