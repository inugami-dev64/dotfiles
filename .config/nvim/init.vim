syntax on

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set autoread
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set number

if has('termguicolors')
    set termguicolors
endif

" Change window postion
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

map <C-l> 5zl
map <C-h> 5zh
map <C-j> 2<C-e>
map <C-k> 2<C-y>

call plug#begin('~/.vim/plugged')
    Plug 'makerj/vim-pdf'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'tikhomirov/vim-glsl'
    Plug 'ackyshake/VimCompletesMe'
    Plug 'beyondmarc/hlsl.vim'
    Plug 'preservim/nerdcommenter'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'itchyny/lightline.vim'
    Plug 'morhetz/gruvbox'
    Plug 'preservim/nerdtree'
    Plug 'altercation/vim-colors-solarized'
call plug#end()


" Initialise clangd if possible
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd', '-header-insertion=never']},
            \ 'whitelist': ['c', 'cpp'],
        \ })

        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
    augroup end
endif
    

" Change the leader key to space
let mapleader = " "

map <Leader>uu aü<ESC>
map <Leader>o aö<ESC>
map <Leader>a aä<ESC>
map <Leader>uo aõ<ESC>


" NERDTree configuration
let NERDTreeShowHidden = 1

" C/C++ highlighter plugin configuration
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1

" Include sortgroup script for sorting groups of data with ease
runtime sortgroup.vim
colorscheme gruvbox
