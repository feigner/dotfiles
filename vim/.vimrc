" eagerly load plugins
source ~/.config/nvim/plugins.vim

let g:mapleader = "\\"
set nocompatible                " let's be explicit

"
" options
"

" UI
set cursorline                   " highlight the current line
set number                       " show line numbers
set signcolumn=number            " squash gitgutter into numcolumn
set numberwidth=3                " svelte line numbers
set noerrorbells                 " no beepz
set novisualbell                 " no bells
set belloff=all                  " for real, no bells
set fillchars=eob:\              " remove `~` on empty lines
set textwidth=0                  " nowrap pls
set titlestring=%t               " filename no path
set nofoldenable                 " dont fold by default
syntax on                        " enable syntax highlighting

" whitespace helper (:set list / :set nolist)
set nolist
if has('multi_byte') && &encoding ==# 'utf-8'
    let &listchars = 'eol:$,trail:~,tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
    let &listchars = 'eol:$,trail:~,tab:> ,extends:>,precedes:<,nbsp:.'
endif

" Indentation
filetype plugin indent on        " Load plugins according to detected filetype.
set expandtab                    " use spaces instead of tabs
set shiftwidth=4                 " >> indents by 4 spaces
set tabstop=4                    " tab width
set softtabstop=4                " tab indents by 4 spaces
set autoindent                   " indent according to previous line
set smartindent                  " smart autoindenting

" tabline + statusline
set showtabline=2                " show tabline
set laststatus=3                 " show statusline (3 == global, nvim only)
set noshowmode                   " noshow mode, handled by statusline

" Clipboard
set clipboard=unnamed            " use system clipboard

" Search
set ignorecase                   " case insensitive search
set smartcase                    " override case insensitivity if uppercase letters exist
set hlsearch                     " highlight search results
set incsearch                    " incremental search
set showmatch                    " highlight matching paren, bracket, brace, etc

" Splits
set splitbelow                   " horizontal splits below
set splitright                   " vertical splits to the right
set equalalways                  " resize splits automatically

" Performance
set timeoutlen=400               " key mapping timeout

" Wildmenu
set wildmenu                     " Enhanced command-line completion
set wildmode=longest:full,full   " tab completes longest common match
set wildignore=*.o,*.obj,*.pyc,.git,*.class,env,**/node_modules/**,node_modules,target/**,**/target/*

" Folding
set foldmethod=indent            " Fold based on indentation
set foldnestmax=10               " Maximum nested folds
set nofoldenable                 " Don't fold by default

" Miscellaneous
set hidden                       " Enable background buffers
set title                        " Show file title

set mouse=a                      " Enable mouse support

" Navigation and Editing
set backspace=indent,eol,start   " Allow backspacing over indents, line endings, and the start of insert
set wrapscan                     " Searches wrap around the end of the file

" Display and Redraw
set display=lastline             " Ensure the last line of a file is always displayed
set showcmd                      " Display incomplete commands in the status line
set ttyfast                      " Assume a fast terminal connection for better performance
set lazyredraw                   " Redraw only when necessary, improves performance in macros and scripts

" History + Backup + Swap
set history=1000                 " gimme more
set undofile                     " persistent undo
set undolevels=2000              " gimme more
set undodir=$HOME/.config/nvim/.undo/    " stash 'em
set nobackup                     " no backup file
set writebackup                  " safety first
set noswapfile                   " don't care
set viminfo='100,:1000,/1000,n$HOME/.config/nvim/.viminfo " Save lots of marks, commands, searches

" theme
set termguicolors                " Enable true color support
set background=dark              " Set dark background theme
let base16colorspace=256         " Use 256 colors
colorscheme base16-eff           " Set colorscheme

" transparent BG (TODO: put this in theme?)
hi NonText guibg=NONE ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi WinSeparator guibg=NONE ctermbg=NONE
hi GitGutterAdd guibg=NONE ctermbg=NONE
hi GitGutterChange guibg=NONE ctermbg=NONE
hi GitGutterDelete guibg=NONE ctermbg=NONE
hi GitGutterChangeDelete guibg=NONE ctermbg=NONE

let g:fzf_colors = {
\ 'fg':         ['fg', 'Normal'],
\ 'bg':         ['bg', 'Normal'],
\ 'preview-bg': ['bg', 'NormalFloat'],
\ 'hl':         ['fg', 'Comment'],
\ 'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':        ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+':        ['fg', 'Statement'],
\ 'info':       ['fg', 'PreProc'],
\ 'border':     ['fg', 'Ignore'],
\ 'prompt':     ['fg', 'Conditional'],
\ 'pointer':    ['fg', 'Exception'],
\ 'marker':     ['fg', 'Keyword'],
\ 'spinner':    ['fg', 'Label'],
\ 'header':     ['fg', 'Comment'] }

"
" plugins
"

" sneak
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
hi! link Sneak Search

" fzf splits
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-h': 'split',
    \ 'ctrl-v': 'vsplit'
    \ }

" lightline status bar
source ~/.config/nvim/colors/base16-eff-lightline.vim
let g:lightline = {
    \ 'colorscheme': 'eff',
    \ 'active': {
    \   'left': [['mode', 'paste'], ['filename'], ['gitbranch', 'modified']],
    \   'right': [['lineinfo'], ['percent']]},
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead',
    \   'filename': 'LightlineFilename',},
    \ 'tabline': {
    \   'left': [['buffers']]},
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers'},
    \ 'component_type': {
    \   'buffers': 'tabsel'},
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ 'tabline_separator': { 'left': '', 'right': ''},
    \ 'tabline_subseparator': { 'left': '', 'right': ''}}

" Display the current file path relative to the git root directory,
" Otherwise show relative path from cwd
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" gitgutter
set updatetime=500

" ale


let g:ale_fixers = {
  \   '*': ['trim_whitespace'],
  \   'python': ['ruff', 'ruff_format'],
  \}
let g:ale_linters = {
  \'python': ['ruff'],
  \}

"
" mappings
"

" RIP arrows
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" jk chord -> esc
inoremap jk <esc>

" clear searches
nnoremap <leader><space> :noh<cr>

" fzf
nnoremap <silent> <leader><leader> :FZF -m<CR>
nnoremap <silent> <leader>f :Ag <CR>
nnoremap <silent> <leader>b :Buffers <CR>
nnoremap <silent> <leader>s :BLines <CR>
nnoremap <silent> <leader>w :Windows <CR>

" buffers
nmap <leader>T :enew<CR>
nmap <leader>] :bnext<CR>
nmap <leader>[ :bprevious<CR>
nmap <leader>bl :ls<CR>

" commenting
nmap <leader>c<space> :TComment<CR>
vmap <leader>c<space> :TComment<CR>

" pane nav
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" ez splits
nnoremap <leader>- :split<CR>
nnoremap <leader>\| :vsplit<CR>


" reload vim
map <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" ale fixer
map <leader>af :ALEFix<CR>

"
" commands / actions
"

" Highlight the trailing whitespace on buffer open / leaving the insert mode.
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Enable cursorline only in the active window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Resize splits on window resize
autocmd VimResized * wincmd =
