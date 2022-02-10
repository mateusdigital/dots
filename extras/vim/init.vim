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
set clipboard^=unnamed,unnamedplus
" Make the spaces visible.
:set encoding=utf-8
:set listchars=trail:·
:set listchars=space:·
:set list
set showtabline=2               " File tabs allways visible


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

    Plug 'scrooloose/nerdtree'

    " Editing
    Plug 'tpope/vim-commentary'

    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'nvim-lua/diagnostic-nvim'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

colorscheme codedark
" colorscheme gruvbox

"-----------------------------------------------------------------------------"
" Remappings                                                                  "
"-----------------------------------------------------------------------------"
"------------------------------------------------------------------------------
" Remove all trailing spaces from the given file types.
autocmd FileType c,cpp,java,php,info,md,vim autocmd BufWritePre <buffer> %s/\s\+$//e


"-----------------------------------------------------------------------------"
" Remappings                                                                  "
"-----------------------------------------------------------------------------"
"------------------------------------------------------------------------------
let mapleader = " "
nnoremap <leader>ww :set wrap!<CR>
nnoremap <leader>v  :e   $MYVIMRC<CR>
nnoremap <leader>V  :so  $MYVIMRC<CR>

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
nnoremap <leader><space> :Files<CR>
nnoremap <leader>ff      :Rg<CR>

"------------------------------------------------------------------------------
" 'scrooloose/nerdtree'
nnoremap <M-t>     :NERDTreeToggle<CR>
nnoremap <leader>t :NERDTreeFind<CR>

nnoremap <silent><c-h> :vertical resize -5<CR>
nnoremap <silent><c-l> :vertical resize +5<CR>
nnoremap <silent><c-j> :resize -5<CR>
nnoremap <silent><c-k> :resize +5<CR>

nnoremap <silent><M-h> :TmuxNavigateLeft<CR>
nnoremap <silent><M-l> :TmuxNavigateRight<CR>
nnoremap <silent><M-j> :TmuxNavigateDown<CR>
nnoremap <silent><M-k> :TmuxNavigateCR>

nnoremap <M-r> :tabprevious<cr>
nnoremap <M-e> :tabnext<cr>
