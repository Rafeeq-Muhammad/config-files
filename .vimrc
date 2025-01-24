set number
set incsearch
set ignorecase
set hlsearch
set smartcase

" Enable modern Vim features not compatible with Vi spec
set nocompatible

" Map F5 to compile and run the current C++ file
autocmd FileType cpp nnoremap <F5> :w<CR>:!g++ -std=c++17 % -o %< && ./%<<CR>

" Enable filetype detection, plugin, and indent
filetype plugin indent on

" Set indentation settings for C++ files
autocmd FileType cpp setlocal autoindent
autocmd FileType cpp setlocal smartindent
autocmd FileType cpp setlocal cindent
autocmd FileType cpp setlocal tabstop=4
autocmd FileType cpp setlocal shiftwidth=4
autocmd FileType cpp setlocal expandtab

" Automatically add closing characters for C++ files
autocmd FileType cpp inoremap { {}<Left>
autocmd FileType cpp inoremap ( ()<Left>
autocmd FileType cpp inoremap [ []<Left>

