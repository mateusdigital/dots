" Defaut Options
set mouse=a
set splitright
set splitbelow
set expandtab
set tabstop=2
set shiftwidth=2
set number
set ignorecase
set smartcase
set incsearch
set diffopt+=vertical
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set signcolumn=yes
set updatetime=500





filetype plugin indent on

if (has("termguicolors"))
   set termguicolors
endif


" Plugins
call plug#begin("~/.vim/plugged")
  Plug 'tomasiser/vim-code-dark'
  Plug 'szw/vim-maximizer'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'itchyny/lightline.vim'
  Plug 'kassio/neoterm'
  Plug 'tpope/vim-commentary'
  Plug 'kassio/neoterm'

call plug#end()

" Plugins Options
let g:netrw_banner=0
colorscheme codedark


" Remappings
let mapleader = " "
  " .vimrc
nnoremap <leader>v :e $MYVIMRC<CR>
  " szw/vim-maximizer
noremap <leader>m :MaximizerToggle!<CR>
  " kassio/neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size        = 60
let g:neoterm_autoinsert  = 1
nnoremap <c-q> :Ttoggle<CR>
inoremap <c-q> <Esc> :Ttoggle<CR>
tnoremap <c-q> <c-\><c-n> :Ttoggle<CR>
