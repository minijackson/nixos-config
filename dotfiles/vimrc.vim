" Some global variables are defined in ../vim.nix

set undofile
set backup
set backupdir-=.

set mouse=a

set ignorecase
set smartcase

set smartindent
set tabstop=4
set shiftwidth=4

set inccommand=split

set scrolloff=1
set sidescrolloff=5

set colorcolumn=80

set termguicolors
let g:gruvbox_contrast_dark = 'soft'
set background=dark
colorscheme gruvbox

" Doesn't do anything because the tabline gets overwritten by lightline
"exe 'hi! TabLineSel guifg=' . g:dominant_color

let g:lightline = {
			\ 'colorscheme': 'gruvbox',
			\ 'subseparator':         { 'left': '|', 'right': '|' },
			\ 'tab_linesubseparator': { 'left': '|', 'right': '|' },
			\ }

set noshowmode

set listchars=tab:│\ ,trail:-,nbsp:+
set list

set fillchars=fold:─,vert:│

highlight ExtraWhitespace term=inverse cterm=inverse gui=inverse
" Show trailing whitespace and spaces before tabs:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

set completefunc=syntaxcomplete#Complete

let g:deoplete#enable_at_startup = 1
