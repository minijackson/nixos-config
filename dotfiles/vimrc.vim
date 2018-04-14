" Some global variables are defined in ../vim.nix

" Better default options {{{

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

set modeline

let g:maplocalleader = ','
let g:mapleader = ';'

" If previously opened jump to the last position in the file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" }}}

" Colors, Statusline, Tabline, Code display {{{

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

" }}}

" Mappings {{{

call camelcasemotion#CreateMotionMappings(g:maplocalleader)

nmap =of :set <C-R>=(&formatoptions =~ "a") ? 'formatoptions-=a' : 'formatoptions+=a'<CR><CR>

" }}}

set completefunc=syntaxcomplete#Complete

" Deoplete {{{

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif

" From *vimtex-complete-deoplete* documentation
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete

let g:deoplete#enable_at_startup = 1

" }}}

" vim: fdm=marker
