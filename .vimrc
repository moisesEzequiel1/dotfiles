let mapleader = ","
set encoding=utf-8
set fileencoding=utf-8


syntax on

au VimLeave * :!clear

set formatoptions+=w

set tw=79

set pastetoggle =<F2>
set nocompatible 
set cursorline
set mouse=a
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set hlsearch
set ignorecase

noremap <expr> <C-U> repeat("\<C-y>", 15)
noremap <expr> <C-E> repeat("\<C-e>", 15)
set belloff=all
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
set updatetime=100

let g:vim_http_tempbuffer=1
let g:vim_http_split_vertically=1

nnoremap <leader>tt :Http<cr><bar><c-w>l

call plug#begin('~/.vim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'sheerun/vim-polyglot'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'cdelledonne/vim-cmake'
    Plug 'alepez/vim-gtest'
    Plug 'jiangmiao/auto-pairs'
    
    " Plugins latex
    Plug 'lervag/vimtex'
    " http client
    Plug 'https://github.com/nicwest/vim-http.git'
    " fuzzy file finding
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
call plug#end()

colorscheme gruvbox 
set background=light
let g:gruvbox_contrast_light="soft"
highlight ColorColumn ctermbg=7 guibg=lightgrey

let g:fzf_layout = { 'down': '40%' }
nnoremap <C-p> :GFiles<Cr>
" c fast compiler
autocmd filetype cpp nnoremap <F4> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
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

" Gtestundercursor
nmap <leader>gt :GTestRunUnderCursor<cr>


nnoremap <leader>pv :w <cr><bar>:wincmd v<bar> :Ex <bar> :vertical resize 30<cr>
nnoremap <leader>+ :vertical resize +5<cr>
nnoremap <leader>- :vertical resize -5<cr>
nnoremap <leader>rp :vertical resize 100<cr>

nmap <leader>gj :diffget //3<cr>
nmap <leader>gf :diffget //2<cr>
nmap <leader>gs :G<cr>

" Navigating with guides
"	inoremap ;gui <++>
"	inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
"	vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
"	map <leader><leader> <Esc>/<++><Enter>"_c4l
"
""""LATEX
"	" Code snippets
"	autocmd FileType tex inoremap ,fr \begin{frame}<Enter>\frametitle{}<Enter><Enter><++><Enter><Enter>\end{frame}<Enter><Enter><++><Esc>6kf}i
"	"autocmd FileType tex inoremap ,fi \begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
"	autocmd FileType tex inoremap ,fi \begin{figure}<Enter>\centering<Enter>\includegraphics{<++>}<Enter>\caption{<++>}<Enter>\label{fig:<++>}<Enter>\end{figure}<Enter><Enter><++><Esc>3kA
"	autocmd FileType tex inoremap ,em \emph{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,bf \textbf{}<++><Esc>T{i
"	autocmd FileType tex vnoremap , <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<Enter>a
"	autocmd FileType tex inoremap ,it \textit{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,ct \textcite{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,cp \parencite{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
"	autocmd FileType tex inoremap ,x \begin{xlist}<Enter>\ex<Space><Enter>\end{xlist}<Esc>kA<Space>
"	autocmd FileType tex inoremap ,ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
"	autocmd FileType tex inoremap ,ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
"	autocmd FileType tex inoremap ,li <Enter>\item<Space>
"	autocmd FileType tex inoremap ,ref \ref{}<Space><++><Esc>T{i
"	autocmd FileType tex inoremap ,tab \begin{tabular}<Enter><++><Enter>\end{tabular}<Enter><Enter><++><Esc>4kA{}<Esc>i
"	autocmd FileType tex inoremap ,ot \begin{tableau}<Enter>\inp{<++>}<Tab>\const{<++>}<Tab><++><Enter><++><Enter>\end{tableau}<Enter><Enter><++><Esc>5kA{}<Esc>i
"	autocmd FileType tex inoremap ,sc \textsc{}<Space><++><Esc>T{i
"	autocmd FileType tex inoremap ,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,sec \section{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,st <Esc>F{i*<Esc>f}i
"	autocmd FileType tex inoremap ,beg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
"	autocmd FileType tex inoremap ,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
"	autocmd FileType tex nnoremap ,up /usepackage<Enter>o\usepackage{}<Esc>i
"	autocmd FileType tex inoremap ,tt \texttt{}<Space><++><Esc>T{i
"	autocmd FileType tex inoremap ,bt {\blindtext}
"	autocmd FileType tex inoremap ,nu $\varnothing$
"	autocmd FileType tex inoremap ,col \begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
"	autocmd FileType tex inoremap ,rn (\ref{})<++><Esc>F}i


autocmd colorscheme * hi clear SpellBad
autocmd colorscheme * hi SpellBad cterm=underline
hi clear SpellBad 
hi SpellBad ctermfg=NONE ctermbg=NONE cterm=underline

set spelllang=es

imap <F5> <esc>:setlocal spell! spelllang=es<cr>


