call plug#begin('~/.vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'sheerun/vim-polyglot'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/syntastic'
  Plug 'airblade/vim-gitgutter'
  Plug 'vim-airline/vim-airline'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'w0rp/ale'
call plug#end()

syntax on
set encoding=UTF-8
set termguicolors
set re=0 " Use new regular expression engine
set number " show line numbers
set relativenumber
" set tabstop=4
" set shiftwidth=4
set autoindent
set hlsearch " highlight all results
set ignorecase " ignore case in search
set smartcase
set mouse=a
set noswapfile " disable the swapfile
set incsearch " show search results as you type

" j+k key combo to escape
inoremap jk <ESC>
" Copy to OS clipboard
vmap <leader>y "*y

" ----------
" w0rp/ale {
" ----------
let g:ale_fixers = {
\  'javascript': ['eslint', 'prettier'],
\  'typescript': ['eslint', 'prettier'],
\  'css': ['prettier'],
\}

let g:ale_fix_on_save = 1
" }

" -------------------
" neoclide/coc.nvim {
" -------------------
" Make <CR> accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" }

" --------------
" junegunn/fzf {
" --------------
" fzf ctrl + P
nnoremap <silent> <C-p> :FZF<CR>
" }

