
let mapleader=','
syntax on
set pastetoggle=<F2>
set nocompatible 
set cursorline
set mouse=a
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set hlsearch
set noerrorbells
set clipboard=unnamed
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set nu
set rnu
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set shortmess+=c
set signcolumn=number
set incsearch
set colorcolumn=80
set updatetime=300

call plug#begin('~/.vim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'sheerun/vim-polyglot'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'cdelledonne/vim-cmake'

call plug#end()

colorscheme gruvbox 
set background=light
let g:gruvbox_contrast_dark="soft"
highlight ColorColumn ctermbg=0 guibg=lightgrey

nnoremap <leader>q :!python3 %<cr>
nnoremap <Leader>x :!node % <cr>
 " use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
" C config id" C config idee
let g:cmake_link_compile_commands = 1
nmap <leader>cg :CMakeGenerate<cr>
nmap <leader>cb :CMakeBuild<cr>
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

"inoremap <silent><expr> <c-@> coc#refresh()
"use <c-space>for trigger completion
inoremap <silent><expr> <c-@> coc#refresh()
"Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)



nnoremap <leader>pv : wincmd v<bar> :Ex <bar> :vertical resize 30<cr>
nnoremap <leader>+ :vertical resize +5<cr>
nnoremap <leader>- :vertical resize -5<cr>
nnoremap <leader>rp :vertical resize 100<cr>

nmap <leader>gh :diffget //3<cr>
nmap <leader>gu :diffget //2<cr>
nmap <leader>gs :G<cr>


