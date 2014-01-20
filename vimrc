" vundle stuff
let mapleader=","
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle "gmarik/vundle"
Bundle "tsaleh/vim-matchit"
Bundle "tpope/vim-ragtag.git"
Bundle "tpope/vim-repeat.git"
Bundle "tpope/vim-surround.git"

Bundle "majutsushi/tagbar.git"
    nnoremap <silent> <leader>t :TagbarToggle<cr>
    nnoremap <silent> <leader>r :TagbarOpenAutoClose<cr>

Bundle "mileszs/ack.vim.git"
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"

Bundle "scrooloose/syntastic.git"
    let g:syntastic_python_checkers = ["python", "pyflakes", "pep8"]

Bundle "bling/vim-airline"
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_detect_modified = 0

syntax on
filetype plugin indent on

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
set laststatus=2
set statusline=[%n]\ %m%f\ %r%h%w%=\%5k\ %4l,%3v\ %3p%%\ %4LL\ [type=%Y]

" python specific syntax setting
let python_highlight_all = 1

" autocommand for closetag.vim
autocmd FileType html,xml,xsl,ant source ~/.vim/scripts/closetag.vim

" colorscheme settings
let g:gruvbox_italicize_comments = 0
set background=dark
colorscheme gruvbox
if exists("+colorcolumn")
    "highlight ColorColumn ctermbg=236
    set colorcolumn=80
endif

" set next/previous tab commands to switch buffers instead
nnoremap gt :bn<CR>
nnoremap gT :bp<CR>
inoremap jj <ESC>
" quickly turn off search highlighting
nnoremap <leader>/ :nohlsearch<cr>
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
nnoremap <leader>s :call <SID>ToggleNumber()<cr>

function! s:ToggleNumber()
    if &number
        set relativenumber
    else
        set number
    endif
endfunction
