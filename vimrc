call pathogen#infect()
call pathogen#helptags()

set hidden
set showcmd showmatch
set number
set cursorline
set visualbell
set nosmartindent
set scrolloff=3
set list listchars=tab:↦\ ,trail:•
set incsearch hlsearch ignorecase smartcase
set smarttab expandtab shiftwidth=4 tabstop=4
set wildmenu wildmode=longest,list,full
" statusline settings
set laststatus=2
set statusline=[%n]\ %m%f\ %r%h%w%=\%5k\ %4l,%3v\ %3p%%\ %4LL\ [type=%Y]
" vim-airline font settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" python specific syntax setting
let python_highlight_all = 1
let g:syntastic_python_checkers = ["python", "pyflakes", "pep8"]
" ack.vim setting
let g:ackprg="ack-grep -H --nocolor --nogroup --column"
" autocommand for closetag.vim
autocmd FileType html,xml,xsl,ant source ~/.vim/scripts/closetag.vim

syntax on
filetype indent on
filetype plugin on

" colorscheme settings
let g:gruvbox_italicize_comments = 0
set background=dark
colorscheme gruvbox
if exists("+colorcolumn")
    "highlight ColorColumn ctermbg=236
    set colorcolumn=80
endif


"leader key. Insert mappings below
let mapleader=","

" set next/previous tab commands to switch buffers instead
nnoremap gt :bn<CR>
nnoremap gT :bp<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>
" maybe this will help with arm pains I'm having?
inoremap jj <ESC>
" insert the current date in nice format
inoremap <leader>d <C-r>=strftime('%d %B %Y')<CR>
" copy entire buffer to system clipboard and jump back to original position
nnoremap <leader>c :%y +<cr>
" quickly switch to previous buffer
nnoremap <leader>v <C-^>
" erase all trailing whitespace
nnoremap <leader>w :%s/\s\+$//g<CR>``
" surround selection in XML comment tags
vnoremap <leader>x :s/.*/<!-- & -->/<CR>
" :grep for word under cursor
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<C-U>call <SID>GrepOperator(visualmode())<cr>
" switch between number and relativenumber
nnoremap <leader>s :call <SID>ToggleNumber()<cr>
" quickly turn off search highlighting
nnoremap <leader>/ :nohlsearch<cr>
" tagbar mappings
nnoremap <silent> <leader>t :TagbarToggle<cr>
nnoremap <silent> <leader>r :TagbarOpenAutoClose<cr>


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

function! s:ToggleNumber()
    if &number
        set relativenumber
    else
        set number
    endif
endfunction
