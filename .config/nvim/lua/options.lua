-- MISC
vim.o.hidden          = true
vim.o.mouse           = "a"
vim.o.ignorecase      = true
vim.o.clipboard       = "unnamedplus"
vim.o.cmdheight       = 1
vim.o.conceallevel    = 0
vim.o.fileencoding    = "utf-8"
vim.o.hlsearch        = false
vim.o.showmode        = false
vim.o.showtabline     = 2
vim.o.sidescrolloff   = 8
vim.o.spell           = false
vim.o.spelllang       = "en_us"
vim.o.splitbelow      = true
vim.o.splitright      = true
vim.o.termguicolors   = true
vim.o.title           = true
vim.o.updatetime      = 300
vim.o.timeoutlen      = 300
vim.wo.cursorline     = true
vim.wo.number         = true
vim.wo.relativenumber = false
vim.opt.numberwidth   = 3
vim.wo.signcolumn     = "yes"
vim.o.wrap            = false

-- Tab / Indent
vim.o.expandtab   = true
vim.o.smartcase   = true
vim.o.smartindent = true
vim.o.smarttab    = true
vim.o.softtabstop = 4
vim.o.shiftwidth  = 4
vim.o.tabstop     = 4

-- Backup
vim.o.undodir         = vim.fn.stdpath "cache" .. "/undo"
vim.opt.undofile      = true
vim.opt.swapfile      = false
vim.opt.backup        = false
vim.opt.writebackup   = false


vim.cmd [[colorscheme codedark]]
