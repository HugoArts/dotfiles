" vundle stuff
let mapleader=","
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim.git'
Plugin 'tmhedberg/matchit.git'
Plugin 'tpope/vim-ragtag.git'
Plugin 'tpope/vim-repeat.git'
Plugin 'tpope/vim-surround.git'
Plugin 'tpope/vim-markdown.git'
Plugin 'tpope/vim-haml'
Plugin 'elzr/vim-json.git'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/html5.vim.git'

Plugin 'kien/ctrlp.vim.git'
    let g:ctrlp_root_markers = [".ctrlp_root"]

Plugin 'majutsushi/tagbar.git'
    nnoremap <silent> <leader>t :TagbarToggle<cr>
    nnoremap <silent> <leader>r :TagbarOpenAutoClose<cr>

Plugin 'mileszs/ack.vim.git'
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"

Plugin 'scrooloose/syntastic.git'
    let g:syntastic_python_checkers = ["python", "pyflakes", "pep8"]

Plugin 'bling/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_detect_modified = 0
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    " unicode symbols
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.whitespace = 'Ξ'

call vundle#end()
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
" copy entire buffer to system clipboard
nnoremap <leader>c :%y "+<cr>
" quickly switch to previous buffer
nnoremap <leader>v <C-^>
" erase all trailing whitespace
nnoremap <leader>w :%s/\s\+$//g<CR>``
" surround selection in XML comment tags
vnoremap <leader>x :s/.*/<!-- & -->/<CR>
" switch between number and relativenumber
nnoremap <leader>s :call <SID>ToggleNumber()<cr>

function! s:ToggleNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction
