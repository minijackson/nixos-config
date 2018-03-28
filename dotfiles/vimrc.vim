" Some global variables are defined in ../vim.nix

set undofile
set backup
set backupdir-=.

set mouse=a

set ignorecase
set smartcase

set termguicolors
let g:gruvbox_contrast_dark = 'soft'
set background=dark
colorscheme gruvbox
exe "hi! TabLineSel guifg=" . g:dominant_color

set listchars=tab:│\ ,trail:-,nbsp:+
set list

set fillchars=fold:─,vert:│

highlight ExtraWhitespace term=inverse cterm=inverse gui=inverse
" Show trailing whitespace and spaces before tabs:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

set smartindent
set tabstop=4

set completefunc=syntaxcomplete#Complete

let g:deoplete#enable_at_startup = 1
