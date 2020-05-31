set nocompatible              " be iMproved, required
filetype off                  " required

" leader is comma
let mapleader=","

" tab width
set tabstop=2
set softtabstop=2
" tabs to spaces
set expandtab

" redraw only when have to (e.g. don't do it during macros)
set lazyredraw

" search while typing, highlight matches
set incsearch
set hlsearch
" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" For regular expressions turn magic on
set magic

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Enable spell check (`z=` to show corrections)
set spell spelllang=en_us
" Check spelling only in insert mode.
" autocmd InsertEnter * setlocal spell
" autocmd InsertLeave * setlocal nospell
" Use c-N in insert mode to complete word
set complete+=kspell

set ruler
