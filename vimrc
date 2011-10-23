"=====================================================================
" The vimrc file created by Jallen
" Last Change:   2010-03-31
" Maintainer:   Jallen Ouyang <jallen.o.y@gmail.com>
" License:      This file is placed in the public domain.
"=====================================================================

let g:os='linux'

" execute project related configuration in current directory
if filereadable("project.vim")
    source project.vim
endif
if filereadable("project.viminfo")
    rviminfo project.viminfo
endif


let g:linux=0
let g:windows=0
let g:mac=0
if g:os == 'linux' 
    let g:linux=1
endif
if g:os == 'windows'
    let g:windows=1
endif
if g:os == 'mac'
    let g:mac=1
endif

" Global Var Definition
" {{{ Global Var

let mapleader = ","
let mapplocalleader = "\\"

let s:sidewidth=35

" }}} End Global Var

" {{{ Defualt Options
set path+=~/etc/**,/usr/share/vim/vim72/**
set nocompatible
set encoding=utf-8
let &termencoding=&encoding
set fileencodings=utf-8,gbk

"set guioptions=
"set number
set laststatus=1
"``colorscheme freya
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab

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
set matchtime=5
set autoread
set grepprg=grep\ -nH\ $*
" => Search and tags

set ignorecase
set smartcase
set laststatus=1
set hlsearch
set incsearch
set magic

" => Moving around, tabs and buffers

" Specify the behavior when switching between buffers
"try
"  set switchbuf=usetab
"  set showtabline=1 " when > 2
"catch
"endtry

set autoindent
"set cindent

" }}} End options


" Function Definition
" {{{ Functions

function! Do_CsTag()
    let dir = getcwd()
    " {{{ delete files
    if filereadable("tags")
        if(g:windows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:windows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:windows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif "}}}

    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:windows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction

" => Command mode related

func! Cwd()
  let cwd = getcwd()
  return "e " . cwd
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  if g:cmd == g:cmd_edited
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
  endif  
  return g:cmd_edited
endfunc

" execute cmd to current file dir
func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

command! Bclose call <SID>BufcloseCloseIt()

function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

func! Compile()
exec "w"
exec "!gcc % -o %<.out"
endfunc

func! Run()
exec "! ./%<.out"
endfunc

" }}} End Functions

" Maps and Abbrevs
" {{{ all mode

" quick vimrc edition
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>q :wq<cr>
nnoremap <leader>Q :q!<cr>
autocmd! bufwritepost .vimrc source ~/.vimrc

" C-tab is mapped by minibufexp to swith between buffers

"map <F2> :w<cr>
"map <F3> :e .<cr>
"map <F4> :cn<cr>
"map <F5> :call Compile()<CR>
"map <F6> :w \| make<CR>
"map <F7> :call Do_CsTag()<CR>
"map <F8> :TlistToggle<cr>
"map <F8> :silent! Tlist<CR>

nnoremap <leader>p "+p
nnoremap <leader>sn :set number<CR>
nnoremap <leader>un :set nonumber<CR>
nnoremap <silent> <leader><cr> :noh<cr>
"map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
"map <leader>cc :botright cope<cr>
"map <leader>sq :cw<CR>
"map <leader>cl :ccl<CR>
"map <leader>p :cp<cr>
" quick :buf
map <leader>b :buf 
" Close the current window
map <leader>wc <C-W>c
" Close the current buffer
map <leader>bc :Bclose<cr>
" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
"map <C-up> :bp<cr>
"map <C-down> :bn<cr>
"map <C-left> :tabprevious<cr>
"map <C-right> :tabnext<cr>

" Tab configuration
"map <leader>tn :tabnew %<cr>
"map <leader>tc :tabclose<cr>
"map <leader>te :tabedit
"map <leader>tm :tabmove

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>
map <leader>tb  :TMiniBufExplorer<cr>
"Remap VIM 0
map 0 ^
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=
"}}} end map
" {{{ normal mode
"nnoremap <F5> :buffers<CR>:buffer<Space>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <silent> <leader>fe :Sexplore!<cr>
nnoremap <leader><silent><space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
nmap <silent> <leader>wm :WMToggle<cr><cr>
nnoremap <leader>sig :r ~/etc/vim/skeleton_vim.txt<enter>

" }}} End nmap
" {{{ command line mode

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Smart mappings on the command line
cnoreabbrev $h e ~/
cnoreabbrev $d e ~/Desktop/
cnoreabbrev $j e ./
cnoreabbrev $c e <C-\>eCurrentFileDir("e")<cr>
    " <C-\>e  exp replace the cmd line to $exp

" $q is super useful when browsing on the command line
" /usr/lib/asdf$q ---> /usr/lib/
cnoreabbrev $q <C-\>eDeleteTillSlash()<cr>

" }}} end cmap
" {{{ virtual mode
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>

vnoremap <leader>) <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>] <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>{ <esc>`>a<enter>}<esc>`<i{<enter><esc>
vnoremap <leader>} <esc>`>a<enter>}<esc>`<i{<enter><esc>
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>

vnoremap <leader>c <esc>`>a<enter>*/<esc>`<i/*<enter><esc>


" }}} end vmap
" {{{ input mode

" Map auto complete of (, ", ', [
inoremap (<tab> ()<esc>i
inoremap [<tab> []<esc>i
inoremap <<tab> <><esc>i
inoremap {<tab> {<esc>o}<esc>O
inoremap '<tab> ''<esc>i
inoremap "<tab> ""<esc>i

iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab xline "=====================================================================

" }}} end imap

" Auto-commands
" {{{ autocmd

autocmd! bufwritepost .vimrc source ~/.vimrc
autocmd BufRead,BufNew :call UMiniBufExplorer
"Delete trailing white space, useful for Python ;)
"autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" }}} autocmd

" Plugins
" {{{ Plugins

" => taglist plugin

let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Show_One_File = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Show_Menu = 1	    "gui only
let Tlist_Close_On_Select = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Process_File_Always = 0
let Tlist_WinWidth = s:sidewidth

" =>  lookupfile setting
"
let g:LookupFile_MinPatLength = 2  
let g:LookupFile_PreserveLastPattern = 0    
let g:LookupFile_PreservePatternHistory = 1
let g:LookupFile_AlwaysAcceptFirst = 1    
let g:LookupFile_AllowNewFiles = 0       
if filereadable("./filenametags")       
let g:LookupFile_TagExpr = '"./filenametags"'
endif

nnoremap <silent> <leader>lk :LUTags<cr>
nnoremap <silent> <leader>ll :LUBufs<cr>
nnoremap <silent> <leader>lw :LUWalk<cr>

" => netrw setting

let g:netrw_winsize = 30

" => Minibuffer plugin

let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapWindowNavVim = 1

let g:miniBufExplModSelTarget = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplorerMoreThanOne = 2

let g:miniBufExplMaxSize = 2
let g:miniBufExplTabWrap = 1
"let g:miniBufExplSplitBelow=1
"let g:miniBufExplVSplit = 55
"let g:miniBufExplMinSize = s:sidewidth

" => Omnicppcomplete
"set completeopt=menu

" }}} End Plugins

" experiment
" echom ">^.^<"
inoremap <c-u> <esc>viwUea
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
inoremap jk <esc>
inoremap <esc> <nop>
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

autocmd FileType javascript nnoremap <buffer> <localleader>c I//
autocmd FileType python,sh  nnoremap <buffer> <localleader>c I#

onoremap ( i(
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>


" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    au!
    au FileType vim setlocal foldmethod=marker
augroup END
" }}}













