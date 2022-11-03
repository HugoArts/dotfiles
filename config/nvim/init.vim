" basic nvim config
set nocompatible
set hidden
set background="dark"
set termguicolors

set inccommand="split"

set ignorecase
set smartcase

" tab settings
set tabstop=4
set shiftwidth=4
set expandtab
autocmd FileType javascript,typescript,jsx,tsx,html setlocal shiftwidth=2 tabstop=2

" some line highlighting/number settings
set number
set relativenumber
set cc=120
set cursorline

set scrolloff=3

set list
set listchars=tab:↦\ ,trail:•

set wildmode=longest,list,full
set wildignore=*.pyc


let mapleader=","

lua require('plugins')

let g:sonokai_style = 'andromeda'
let g:sonokai_better_performance = 1
colorscheme catppuccin-macchiato

" tab commands switch buffers
nnoremap gt <Cmd>BufferNext<cr>
nnoremap gT <Cmd>BufferPrevious<cr>
nnoremap <leader>t <C-^>
nnoremap <leader>q <Cmd>BufferPick<cr>

" jump back
nnoremap <leader>b <C-O>

" remove search highlight
nnoremap <leader>/ <Cmd>nohlsearch<cr>

" diagnostic mappings
nnoremap <leader>df <Cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <leader>dn <Cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap <leader>dp <Cmd>lua vim.diagnostic.goto_prev()<cr>
nnoremap <leader>dl <Cmd>lua vim.diagnostic.setloclist()<cr>
