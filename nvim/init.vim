execute pathogen#infect()

set nocompatible  " No vi compatibility (this must be first)
set encoding=utf-8

" Show true colors
if !has('gui_running')
  set t_Co=256
  set termguicolors
endif

set autoindent        " New lines preserve the indentation of previous lines
set autoread          " Reload files when changed on disk (ex: via `git checkout`)
set backspace=2       " Use the smart version of backspace
set backspace=indent,eol,start " Fixes common backspace problems
set clipboard=unnamedplus " Yank and paste with the system clipboard
set cursorline        " Highliht current line
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
set mouse=a           " Enable mouse in all modes
set number            " Show line numbers
set ruler             " Always show cursor position
set scrolloff=2       " Show context above/ below cursorline
set shiftwidth=2      " Normal mode indentation commands use 2 spaces
set showcmd           " Show the (partial) command as it's being typed
set smartcase         " Case-sensitive search if any caps
set softtabstop=2     " Insert mode tab and backspace use X spaces
set tabstop=4         " Actual tabs occupy X characters
set title             " Show the filename in the window titlebar
set ttyfast           " Optimize for fast terminal connections
set visualbell        " Flash the screen instead of beeping on errors

" filetype plugin indent on " ?

syntax enable
colorscheme srcery

let g:lightline = {
\ 'colorscheme': 'srcery'
\ }

" -- Key mappings
" Disable the arrow keys in NORMAL mode
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>

" Double <Esc> clears search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Stuff to ignore when tab completing
set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz
set wildignore+=*DS_Store*
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android
