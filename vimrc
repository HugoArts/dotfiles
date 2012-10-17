call pathogen#infect()

set background=dark
colorscheme wombat256mod

" python specific syntax setting
let python_highlight_all = 1
" ack.vim setting
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

syntax on
filetype indent on
filetype plugin on

" some visual options
set hidden
set showcmd
set showmatch
set number
set cursorline
set visualbell
set nosmartindent
set scrolloff=3

" search settings
set incsearch
set ignorecase
set smartcase

" <tab> settings
set smarttab
set expandtab
set shiftwidth=4
set tabstop=4

" completion settings
set wildmenu
set wildmode=longest,list,full

" statusline settings
set laststatus=2
set statusline=[%n]\ %m%f\ %r%h%w%=\%5k\ %4l,%3v\ %3p%%\ %4LL\ [type=%Y]

"leader key. Insert mappings below
let mapleader=","

" set next/previous tab commands to switch buffers instead
nnoremap gt :bn<CR>
nnoremap gT :bp<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>

" maybe this will help with arm pains I'm having?
inoremap jj <ESC>

" copy entire buffer to system clipboard and jump back to original position
nnoremap <leader>c :%y+<cr>

" quickly switch to previous buffer
nnoremap <leader>v <C-^>

" erase all trailing whitespace
nnoremap <leader>w :%s/\s\+$//g<CR>``

" :grep for word under cursor
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<C-U>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_register
endfunction

" switch between number and relativenumber
nnoremap <leader>s :call <SID>ToggleNumber()<cr>

function! s:ToggleNumber()
    if &number
        set relativenumber
    else
        set number
    endif
endfunction

