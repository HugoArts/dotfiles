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
Plugin 'chriskempson/base16-vim.git'

" syntax/coloring support
Plugin 'tpope/vim-markdown.git'
Plugin 'othree/html5.vim.git'
Plugin 'hdima/python-syntax.git'
Plugin 'vim-scripts/django.vim.git'
Plugin 'wting/rust.vim.git'
Plugin 'elzr/vim-json.git'
Plugin 'cespare/vim-toml.git'
Plugin 'tpope/vim-haml'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
    let g:jsx_ext_required = 0

Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'kien/ctrlp.vim.git'
    let g:ctrlp_root_markers = [".ctrlp_root", ".tags"]
    let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
    let g:ctrlp_lazy_update = 150
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_max_files = 0
    let g:ctrlp_match_func = {'match': 'pymatcher#PyMatch'}
    if executable('rg')
        let g:ctrlp_user_command = 'rg -u --files %s'
    endif
    nnoremap <leader>p :CtrlPTag<CR>

Plugin 'rking/ag.vim.git'
    let g:ag_prg="ag --vimgrep"

Plugin 'w0rp/ale'
    let g:ale_linters = {'python': ['flake8', 'mypy']}
    let g:ale_python_flake8_options = "--max-line-length=120"
    let g:ale_python_mypy_options = "--silent-imports"

" Plugin 'scrooloose/syntastic.git'
"     let g:syntastic_python_checkers = ["python", "pyflakes", "pep8"]

Plugin 'vim-airline/vim-airline-themes'

Plugin 'bling/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    for i in range(1, 9)
        execute "nmap <leader>" . i . " <Plug>AirlineSelectTab" . i
    endfor

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


Plugin 'tpope/vim-fugitive.git'
Plugin 'airblade/vim-gitgutter.git'

call vundle#end()
syntax on
filetype plugin indent on

set hidden
set showcmd showmatch
set number relativenumber
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
set tags=./.tags;
set backspace=2
set wildignore+=*.pyc

" python specific syntax setting
let python_highlight_all = 1

" autocommand for closetag.vim
autocmd FileType javascript,html,htmljinja,htmldjango setlocal shiftwidth=2 tabstop=2

" colorscheme settings
" we need to do this before loading airline I think
let base16colorspace=256
if $BACKGROUND == "light"
    set background=light
    colorscheme base16-default-light
else
    set background=dark
    colorscheme base16-default-dark
endif

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
