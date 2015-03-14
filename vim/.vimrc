set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set runtimepath+=~/.vim/bundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"Plugin 'marcweber/vim-addon-manager'
" editor config
Plugin 'editorconfig/editorconfig-vim'
" powerline
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
" nerd tree
Plugin 'scrooloose/nerdtree'
" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
" emmet
Plugin 'mattn/emmet-vim'
" supertab - tab everything
"Plugin 'ervandew/supertab'
" syntax checker
Plugin 'scrooloose/syntastic'
" fuzzy finder
Plugin 'kien/ctrlp.vim'
" git (fugitive)
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
" javascript-syntax
Plugin 'jelera/vim-javascript-syntax'
" js beautify
Plugin 'einars/js-beautify'
Plugin 'maksimr/vim-jsbeautify'
" JSON
Plugin 'elzr/vim-json'
" jshint
Plugin 'walm/jshint.vim'
" coffeescript-syntax
Plugin 'kchmck/vim-coffee-script'
" typescript
Plugin 'leafgarland/typescript-vim'
Plugin 'clausreinke/typescript-tools'
" python
" ropevim - vim refactoring
"Plugin 'python-rope/ropevim'
" pydoc support
Plugin 'fs111/pydoc.vim'
" ag, the silver searcher
Plugin 'rking/ag.vim'
" nerd commenter
Plugin 'scrooloose/nerdcommenter'
" pathogen
"Plugin 'tpope/vim-pathogen'
" snipmate
"Plugin 'MarcWeber/vim-addon-mw-utils'
"Plugin 'tomtom/tlib_vim'
"Plugin 'honza/vim-snippets'
"Plugin 'garbas/vim-snipmate'
" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" coffeescript snippets
Plugin 'carlosvillu/coffeScript-VIM-Snippets'
" node support, completion with recognizing local modules
Plugin 'moll/vim-node'
Plugin 'ahayman/vim-nodejs-complete'
" node debugger
Plugin 'sidorares/node-vim-debugger'
" autosave
"Plugin 'vim-scripts/vim-auto-save'
" instant markdown preview
Plugin 'suan/vim-instant-markdown'
" Matching brackets
Plugin 'Raimondi/delimitMate'
" handle surrouding characters, i.e. ', ", ...
Plugin 'tpope/vim-surround'
" multiple cursors
Plugin 'terryma/vim-multiple-cursors'
" markdown
Plugin 'plasticboy/vim-markdown'
" latex
Plugin 'lervag/vim-latex'
"Plugin 'LaTeX-Box-Team/LaTeX-Box'
" All of your Plugins must be added before the following line
call vundle#end()            " required
" enable syntax processing
syntax on
filetype on
filetype plugin on
filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
"" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" use molokai theme
colorscheme molokai
" use default molokai theme
let g:molokai_original=1
let g:rehash256=1

" syntastic config
let b:syntastic_mode='active'
" enables error reporting in the gutter
let g:syntastic_enable_signs=1
"let g:syntastic_always_populate_loc_list=1
" when there are errors, show the quickfix window that lists those errors
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
" jump to line if error
"let g:syntastic_auto_jump=2
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
" automatically run this every 200ms
augroup syntastic
    autocmd CursorHold * nested update
augroup END
set updatetime=200
" map ,n as jump to next error
nnoremap <leader>n :lnext<CR>

let delimitMate_expand_cr=1
set scrolloff=3
" Set to auto read when a file is changed from the outside
set autoread

syntax on

" leader is comma
let mapleader=","

" tab width
set tabstop=2
set softtabstop=2
" tabs to spaces
set expandtab

" show line numbers
set number

" highlight current line
set cursorline

" visual autocomplete for command menu
set wildmenu
" unset ctrlp command if set
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
" Ignore files
set wildignore+=*.o,*~,*.pyc,*/\.git/*,*/tmp/*,*.so,*.swp,*.zip
" Ignore files in .gitignore (if existant)
let filename = '.gitignore'
if filereadable(filename)
    let igstring = ''
    for oline in readfile(filename)
        let line = substitute(oline, '\s|\n|\r', '', "g")
        if line =~ '^#' | con | endif
        if line == '' | con  | endif
        if line =~ '^!' | con  | endif
        if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
        let igstring .= "," . line
    endfor
    let execstring = "set wildignore+=".substitute(igstring, '^,', '', "g")
    execute execstring
endif


" redraw only when have to (e.g. don't do it during macros)
set lazyredraw

" show matching brackets [{()}]
set showmatch

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

" enable folding
set foldenable
" fold very nested folds by default
set foldlevelstart=10
" allow up to 10 nested folds
set foldnestmax=10
" fold based on indent level
set foldmethod=indent
" space open/closes folds
nnoremap <space> za

" move vertically by visual line (don't skip wrapped line)
nnoremap j gj
nnoremap k gk

" map B/E to move to beginning/end of line
nnoremap B ^
nnoremap E $

" highlight last inserted text
nnoremap gV `[v`]

" jk is escape
"inoremap jk <esc>
"inoremap kj <esc>
inoremap jj <esc>

" insert a single character in normal mode
:nmap <silent> ,s "=nr2char(getchar())<cr>P

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session
nnoremap <leader>s :mksession<CR>

" open ag.vim
nnoremap <leader>a :Ag

" CtrlP settings
let g:ctrlp_match_window='bottom,order:ttb'
let g:ctrlp_switch_buffer=0
let g:ctrlp_working_path_mode='ra'
let g:ctrlp_show_hidden=1
let g:ctrlp_user_command='ag %s -l --nocolor --hidden -g ""'
"let g:ctrlp_map = '<c-p>'
"let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore={
  \ 'dir':  '\v[\/]\.(git|hg)$',
  \ 'file': '',
  \ 'link': '',
  \ }

" use pathogen
call pathogen#infect()
" call pathogen#runtime_append_all_bundles()

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
  " save last search & cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

" jsbeautify
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>

augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    "autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
    autocmd BufWritePre *.*
                \:call <SID>StripTrailingWhitespaces()
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
"func! DeleteTrailingWS()
  "exe "normal mz"
  "%s/\s\+$//ge
  "exe "normal `z"
"endfunc
"autocmd BufWrite *.* :call DeleteTrailingWS()

if exists('&ofu') || exists('g:nodejs_complete_config')
  setlocal omnifunc=nodejscomplete#CompleteJS
endif

" activate powerline
"call vam#ActivateAddons(['powerline'])

" powerline config
set guifont=Inconsolata-g\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set termencoding=utf-8
set t_Co=256
"set term=xterm-256color

" macvim (gui mode) config
if has("gui_running")
  "let s:uname = system("uname")
  "if s:uname == "Darwin\n"
  "set guioptions-=e
endif

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" No annoying sound on errors
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nnoremap <leader>tt :tabnext<CR>
nnoremap <leader>tk :tabprev<CR>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" automatically save file while typing
"let g:auto_save=1
" automatically read file if changed out of editor
set autoread

" set coffeescript syntax
"au BufNewFile,BufRead *.coffee set filetype=coffee

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
:call NumberToggle()
nnoremap <C-n> :call NumberToggle()<cr>

" open nerdtree automatically
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" ultisnips Trigger configuration. Do not use <tab> if you use YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" map expand snippet to kk (insert mode only)
imap kk <c-k>
" map jump to next to ll (insert mode only)
"imap ll <c-l>

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
"let g:ycm_key_list_select_completion=[]
"let g:ycm_key_list_previous_completion=[]

" typescript config
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
let g:typescript_compiler_options='--target ES5'
" typescript tss config
au BufRead,BufNewFile *.ts        setlocal filetype=typescript
set rtp+=~/.node/lib/node_modules/typescript-tools/
" typescript + syntastic
let g:syntastic_typescript_tsc_args='--module commonjs --target ES5'

" latex config
" set working directory
let g:latex_latexmk_build_dir = '.'
" enable latexmk
let g:latex_latexmk_enabled = 1
" run latexmk in background
let g:latex_latexmk_background = 1
" use continious mode - compile every time latex file changes
let g:latex_latexmk_continuous = 1
" options passed to latexmk
let g:latex_latexmk_options = '-pdf' " can also be set in `.latexmkrc` file
" ignore warnings
let g:latex_quickfix_ignore_all_warnings = 1
