" Inspiration ::
" https://github.com/tpope/vim-sensible
" https://github.com/thoughtbot/dotfiles

" My plugins ::
" lightline
" lightline-bufferline
" gruvbox-material color theme
" godlygeek/tabular
" plasticboy/vim-markdown syntax
" junegunn/goyo.vim
" junegunn/limelight.vim
execute pathogen#infect()

set nocompatible  " No vi compatibility (this must be first)
set encoding=utf-8
set termencoding=utf-8

set autoindent        " New lines preserve the indentation of previous lines
set smartindent       " Automatically inserts indentation

set autoread          " Reload files when changed on disk (ex: via `git checkout`)
set backspace=2       " Use the smart version of backspace
set backspace=indent,eol,start " Fixes common backspace problems
set clipboard=unnamedplus " Yank and paste with the system clipboard
set expandtab         " Expand tabs to spaces
set gdefault          " Add the "g" flag to search/replace by default
set history=900       " Increase the UNDO limit
set hlsearch          " Highlight matching search patterns
set ignorecase        " Case-insensitive search
set incsearch         " Search as you type
set laststatus=2      " Always show the status bar
set lazyredraw        " Don't update screen during macro or script execution
set lcs=tab:»·,trail:· " Set characters to show for tabs and trailing whitespace
set list              " Show trailing whitespace
set modelines=0       " Disable modelines as a security precaution
set mouse=a           " Enable mouse in all modes
set nobackup          " Disable backups and swaps
set noswapfile
set nowritebackup
set number            " Show line numbers
set ruler             " Always show cursor position
set scrolloff=2       " Show context above/ below cursorline
set shiftwidth=2      " Normal mode indentation commands use 2 spaces
set showcmd           " Show the (partial) command as it's being typed
set showmatch         " Show matching brackets/parenthesis
set showtabline=2     " Show lightline-bufferline
set sidescrolloff=2   " Show next two columns scrolling
set smartcase         " Case-sensitive search if any caps
set smarttab          " Insert tabs on the start of a line according to context
set softtabstop=4     " Insert mode tab and backspace use X spaces
set tabstop=4         " Actual tabs occupy X characters
set title             " Show the filename in the window titlebar
set ttyfast           " Optimize for fast terminal connections
set visualbell        " Flash the screen instead of beeping on errors
set wildignorecase    " Ignore case in file name completion
set wildmenu          " Show list instead of just completing
set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all

" Show true colors
set t_Co=256       " Force 256 colors
set termguicolors  " Enable 24-bit color
set background=dark
syntax enable

set cursorline " Highlight current line
highlight CursorLine term=reverse
highlight CursorColumn term=reverse

" Visible line at column X
set textwidth=99
set colorcolumn=+1
set wrap linebreak

let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material

filetype plugin indent on
autocmd FileType sh,make set noexpandtab!
autocmd FileType python setlocal ts=4 sts=4 sw=4

" Markdown
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_conceal = 0
" let g:vim_markdown_math = 1

" Lightline status bar
let g:lightline = {
\ 'colorscheme': 'nord',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
\ },
\ 'tabline': {
\   'left': [ ['buffers'] ], 'right': [ [] ]
\ },
\ 'component_expand': {
\   'buffers': 'lightline#bufferline#buffers'
\ },
\ 'component_type': {
\   'buffers': 'tabsel'
\ }
\ }

" Buffers tabs bar
let g:lightline#bufferline#show_number=2
let g:lightline#bufferline#composed_number_map = {
\ 1: '❶', 2: '❷', 3: '❸', 4: '❹', 5: '❺',
\ 6:  '❻', 7:  '❼', 8:  '❽', 9:  '❾', 10: '❿'}

" Stuff to ignore when tab completing
set wildignore=*.a,*.o,*.obj,*.exe,*.pdb,*.lib,*.manifest
set wildignore+=*.so,*.dll,*.jar,*.class,*.dex,*.luac
set wildignore+=*.pyc,*.pyo,*.gem,*.egg,*.egg-info/
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz
set wildignore+=*.DS_Store*,*.bak,*/tmp/*
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.swp,*/.Trash/**,*.dmg,*.rbc,*/.rbenv/**
set wildignore+=*.app,*.git,.git,.hg,.svn
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android
set wildignore+=**/node_modules/**,*/__pycache__/

" -- Key mappings

" Disable the arrow keys in NORMAL mode
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>

" <Esc> clears search highlights
nnoremap <silent> <Esc> <Esc>:nohlsearch<CR><Esc>

" Easy esc from insert
imap jk <esc>

" Make Y act like all the other capital variants
nnoremap Y y$

" Make n always search forward and N backward
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" Make ; always "find" forward and , backward
nnoremap <expr> ; getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'

" Make <c-j>, <c-k>, <c-l>, and <c-h> scroll the screen.
nnoremap <c-j> <c-e>
nnoremap <c-k> <c-y>
nnoremap <c-l> zl
nnoremap <c-h> zh

" Useful shortcuts in cmd mode
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>

let mapleader=','

" Leader+2/4 to change tabs
nnoremap <Leader>2 :set tabstop=2  softtabstop=2 shiftwidth=2<CR>
nnoremap <Leader>4 :set tabstop=4  softtabstop=4 shiftwidth=4<CR>

" Leader+b to open buffers
nnoremap <Leader>b :ls<CR>:b<Space>

" Limelight + Goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
