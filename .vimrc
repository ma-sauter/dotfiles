"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 


" I followed guides from 
" https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/


" Default values{{{

source $VIMRUNTIME/defaults.vim

" }}}

" Enable folding{{{

set foldmethod=manual

" }}}

" My Plugins{{{

call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'github/copilot.vim'
Plug 'scrooloose/nerdtree'

call plug#end()

" }}}

" Vimscript Settings{{{

" Enable folding
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

" }}}

" Status line Settings{{{

set statusline=\ %F%m 
set statusline+=%=
set statusline+=\ line:\ %l\ col:\ %c\ percent:\ %p%%

" Show current file and dimensions
set showmode

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" }}}

" Key mappings{{{

inoremap jj <Esc>

" execute python scripts with f5
nnoremap <F5> :w <CR>:!python3 %<CR>

" navigating split view with ctrl + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree
nnoremap <F3> :NERDTreeToggle<cr>
" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']


" }}}

" Various Settings{{{

" Set highlightsearch case insensitive and incremental and smartcase
set hls ic is smartcase

" Set line numbers
set number

" Use spaces instead of tabs
set expandtab

" Don't wrap lines but make them extend to the right
" set nowrap 

" Enable copying to the system clipboard
set clipboard=unnamedplus

" }}}
