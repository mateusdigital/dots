" Defaut Options
set mouse=a
set splitright
set splitbelow
set expandtab
set tabstop=4
set shiftwidth=4
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
set nowrap

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
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install -all' }
  Plug 'junegunn/fzf.vim'
call plug#end()

" Plugins Options
let g:netrw_banner=0
colorscheme codedark

" Remappings
let mapleader = " "
nnoremap <leader>ww :set wrap!<CR>            " Toggle Wrap Lines
nnoremap <leader>v :e $MYVIMRC<CR>            " Open .vimrc file
  " szw/vim-maximizer
nnoremap <leader>m :MaximizerToggle!<CR>      " Toggle maximize current pane.
  " kassio/neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size        = 60
let g:neoterm_autoinsert  = 1
nnoremap <c-q> :Ttoggle<CR>                   " Toggle side terminal.
inoremap <c-q> <Esc> :Ttoggle<CR>
tnoremap <c-q> <c-\><c-n> :Ttoggle<CR>
  " junegunn/fzf.vim
nnoremap <leader><space> :Files ./<CR>           " Open fuzzy search.
nnoremap <leader>ff :Rg<CR>                   " Open ripgrep.

