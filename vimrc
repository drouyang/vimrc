"=====================================================================
" The vimrc file created by Jiannan Ouyang
" Maintainer:   Jiannan Ouyang <jiannan.ouyang@gmail.com>
" License:      This file is placed in the public domain.
"=====================================================================

" Usage:

" IMPORTANT: <ESC> is unmapped, use jk
" inoremap <esc> <nop>
inoremap jk <esc>:w<cr>

" disable up, down, left, right
"inoremap  <Up>     <nop>
"inoremap  <Down>   <nop>
"inoremap  <Left>   <nop>
"inoremap  <Right>  <nop>
"noremap   <Up>     <nop>
"noremap   <Down>   <nop>
"noremap   <Left>   <nop>
"noremap   <Right>  <nop>

" global and local leader
let mapleader = ","
let mapplocalleader = "\\"

" Fast vimrc Edition
" ,e - edit vimrc
nnoremap <leader>e :e $MYVIMRC<cr>
" ,ev - edit vimrc in vertical split window
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" ,s - source vimrc
nnoremap <leader>s :source $MYVIMRC<cr>
" auto source vimrc after update
autocmd! bufwritepost .vimrc source ~/.vimrc

" ,q - qa 
nnoremap <leader>q :qa<cr>

" ,<N> - buffer
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" paste mode
nnoremap <leader>p :set invpaste paste?<CR>
set pastetoggle=<leader>p

" cscope
set nocscopeverbose  

" MiniBufExpl (MBE)
map <leader>b :TMiniBufExplorer<cr>
" let g:miniBufExplorerMoreThanOne=1

" TagList
map <leader>t :TlistToggle<cr>

" {{{ {},(),<>,'',"",[], <tab> auto close and select - surround
" Map auto complete of (, ", ', [
inoremap (<tab> ()<esc>i
inoremap )<tab> ()<esc>i
inoremap {<tab> {<esc>o}<esc>O
inoremap }<tab> {<esc>o}<esc>O
inoremap [<tab> []<esc>i
inoremap ]<tab> []<esc>i
inoremap "<tab> ""<esc>i
inoremap '<tab> ''<esc>i
inoremap <<tab> <><esc>i
inoremap ><tab> <><esc>i

" selected surround with
vnoremap <leader>) <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>{ <esc>`>a<enter>}<esc>`<i{<enter><esc>
vnoremap <leader>} <esc>`>a<enter>}<esc>`<i{<enter><esc>
vnoremap <leader>[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>] <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>< <esc>`>a><esc>`<i<<esc>
vnoremap <leader>> <esc>`>a><esc>`<i<<esc>
" }}}

" {{{ Defualt Options
set path+=~/etc/**,/usr/share/vim/vim72/**
set nocompatible
set encoding=utf-8
let &termencoding=&encoding
set fileencodings=utf-8,gbk

"set guioptions=
"set number
set laststatus=1
let s:sidewidth=35
if !has('gui_running')
    colorscheme desert256
else
    colorscheme desert
endif
" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

set history=300
set nobackup
set noswapfile
filetype on
filetype plugin indent on
set hidden

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" utilities
set showmatch
set showmode
set matchtime=5
set autoread
set grepprg=grep\ -nH\ $*

" Search and tags
set ignorecase
set smartcase
set laststatus=1
set hlsearch
set incsearch
set magic

" {{{ Indent and Space
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
" }}}

" }}}
" vimrc Display Settings ---------------------- {{{
augroup filetype_vim
    au!
    au FileType vim setlocal foldmethod=marker
augroup END
" }}}



