"-----------------------------------------------------------------------------"
" Default Options                                                             " 
"-----------------------------------------------------------------------------"
set noerrorbells
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
set noswapfile
set cmdheight=1
set undodir=~/.vim/undodir
set undofile
set signcolumn=yes
set updatetime=500
set nowrap


"-----------------------------------------------------------------------------"
" Plugins                                                                     " 
"-----------------------------------------------------------------------------"
"------------------------------------------------------------------------------
call plug#begin()
    " Themes
    Plug 'tomasiser/vim-code-dark'
    Plug 'morhetz/gruvbox'
    " Window / Panels / etc...
    Plug 'szw/vim-maximizer'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install -all' }
    Plug 'junegunn/fzf.vim'
    " Editing 
    Plug 'tpope/vim-commentary'

    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'nvim-lua/diagnostic-nvim'

    " Terminal
    Plug 'itchyny/lightline.vim'
    Plug 'kassio/neoterm'
    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
call plug#end()


"-----------------------------------------------------------------------------"
" Plugins Options                                                             " 
"-----------------------------------------------------------------------------"
"------------------------------------------------------------------------------
let g:netrw_banner=0

filetype plugin indent on
if (has("termguicolors"))
   set termguicolors
endif

colorscheme gruvbox


"-----------------------------------------------------------------------------"
" Remappings                                                                  " 
"-----------------------------------------------------------------------------"
"------------------------------------------------------------------------------
let mapleader = " "
nnoremap <leader>ww :set wrap!<CR>       
nnoremap <leader>v :e $MYVIMRC<CR>        

"------------------------------------------------------------------------------
" szw/vim-maximizer
nnoremap <leader>m :MaximizerToggle!<CR>   

"------------------------------------------------------------------------------
" kassio/neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size        = 60
let g:neoterm_autoinsert  = 1
nnoremap <c-q> :Ttoggle<CR>                 
inoremap <c-q> <Esc> :Ttoggle<CR>
tnoremap <c-q> <c-\><c-n> :Ttoggle<CR>

"------------------------------------------------------------------------------
" junegunn/fzf.vim
nnoremap <leader><space> :Files ./<CR>       
nnoremap <leader>ff :Rg<CR>                   

