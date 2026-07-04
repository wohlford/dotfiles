" Based on Steve Losh's 'Coming Home to Vim' (stevelosh.com/blog/2010/09/coming-home-to-vim)

" Use Vim's full feature set, not Vi compatibility mode
set nocompatible

" Disable modelines for security
set modelines=0

" Indentation settings: 2 spaces for a tab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent

" Use UTF-8 encoding
set encoding=utf-8

" Scroll offset and display settings
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ruler

" Configure backspace behavior
set backspace=indent,eol,start

" Line length guide
set textwidth=88
set colorcolumn=+1
autocmd FileType gitcommit set textwidth=72

" Always display status line
set laststatus=2

" Show relative line numbers with absolute on current line
set number
set relativenumber

" Persistent undo, no swap or backup files
set undofile
set undodir=~/.vim/undo
set noswapfile
set nobackup
set nowritebackup

" Show invisible whitespace
set listchars=tab:»·,trail:·
set list

" Use very magic mode for regex and mapping / in normal and visual mode
nnoremap / /\v
vnoremap / /\v

" Search settings: case-insensitive unless capital letter used
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

" Map <tab> to jump to matching pairs
nnoremap <tab> %
vnoremap <tab> %

" Enable line wrapping
set wrap

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Map semicolon to colon for command mode access
nnoremap ; :

" Map 'jj' to escape in insert mode
inoremap jj <ESC>

" Control + hjkl game-like for window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Enable syntax highlighting if available
if has("syntax")
  syntax on
endif
