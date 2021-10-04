"{ Builtin options and settings
" Changing fillchars for folding, so there is no garbage charactes
set fillchars=fold:\ ,vert:\|

" Split window below/right when creating horizontal/vertical windows
set splitbelow splitright

" General tab settings
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set noexpandtab     " do not expand tab to spaces

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」

" Show line number and relative line number
set number relativenumber

" Ignore case in general, but become case-sensitive when uppercase is present
set ignorecase smartcase

" File and script encoding settings for vim
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
scriptencoding utf-8

" Break line at predefined characters
set linebreak
" Character to show before the lines that have been soft-wrapped
set showbreak=↪

" List all items and start selecting matches in cmd completion
set wildmode=list:full

" Show current line where the cursor is
set cursorline
" Set a ruler at column 80, see https://goo.gl/vEkF5i
set colorcolumn=80

" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3

" Use mouse to select and resize windows, etc.
if has('mouse')
    set mouse=nv  " Enable mouse in several mode
    set mousemodel=popup  " Set the behaviour of mouse
endif

" Do not show mode on command line since vim-airline can show it
set noshowmode

" Fileformats to use for new files
set fileformats=unix,dos

" The mode in which cursorline text can be concealed
set concealcursor=nc

" The way to show the result of substitution in real time for preview
set inccommand=nosplit

" Ignore certain files and folders when globbing
set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.pyc
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.pdf

" Ask for confirmation when handling unsaved or read-only files
set confirm

" Do not use visual and errorbells
set visualbell noerrorbells

" The level we start to fold
set foldlevel=0

" The number of command and search history to keep
set history=500

" Use list mode and customized listchars
set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:+

" Auto-write the file based on some condition
set autowrite

" Show hostname, full path of file and last-mod time on the window title.
" The meaning of the format str for strftime can be found in
" http://tinyurl.com/l9nuj4a. The function to get lastmod time is drawn from
" http://tinyurl.com/yxd23vo8
set title
set titlestring=
set titlestring+=%(%{hostname()}\ \ %)
set titlestring+=%(%{expand('%:p')}\ \ %)
set titlestring+=%{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}

" Persistent undo even after you close a file and re-open it
set undofile

" Do not show "match xx of xx" and other messages during auto-completion
set shortmess+=c

" Completion behaviour
set completeopt+=noinsert  " Auto select the first completion entry
set completeopt+=menuone  " Show menu even if there is only one item
set completeopt-=preview  " Disable the preview window

" Settings for popup menu
set pumheight=15  " Maximum number of items to show in popup menu
set pumblend=5  " Pesudo blend effect for popup menu

" Align indent to next multiple value of shiftwidth. For its meaning,
" see http://tinyurl.com/y5n87a6m
set shiftround

" Virtual edit is useful for visual block edit
set virtualedit=block

" Do not add two space after a period when joining lines or formatting texts,
" see https://tinyurl.com/y3yy9kov
set nojoinspaces
