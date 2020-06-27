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
set cursorline

set modeline

set title

set wildmode=longest:full,full

let g:maplocalleader = ','
let g:mapleader = ';'

" If previously opened jump to the last position in the file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let &grepprg = g:ripgrep_path . ' --vimgrep $*'
let &grepformat = '%f:%l:%c:%m,' . &grepformat

" }}}

" Colors, Statusline, Tabline, Code display {{{

set termguicolors
let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_italic = 1
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

" Do not set "trail:-" because it messes up the highlighting
set listchars=tab:│\ ,extends:>,precedes:<,nbsp:+
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
set completeopt+=noinsert,noselect

" Deoplete {{{

let g:deoplete#enable_at_startup = 1

" }}}

" Neosnippets {{{

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

set conceallevel=2
set concealcursor=nv

" }}}

" CtrlP {{{
let g:ctrlp_user_command = g:fd_path . ' --type f --color never "" %s'
let g:ctrlp_use_caching = 0
" }}}

" LanguageClient {{{
let g:LanguageClient_loggingFile  = stdpath('data') . '/LanguageClient.log'
let g:LanguageClient_serverStderr = stdpath('data') . '/LanguageServer.log'
" }}}

" VimWiki {{{
	" {'path': '~/Documents/Wiki', 'path_html': '~/Documents/Wiki/html'} \
let g:vimwiki_list = [
	\ {'path': '~/Documents/Wiki/personal', 'path_html': '~/Documents/Wiki/personal/html', 'auto_tags': 1},
	\ {'path': '~/Documents/Wiki/science', 'path_html': '~/Documents/Wiki/science/html', 'auto_tags': 1},
	\ {'path': '~/Documents/Wiki/work', 'path_html': '~/Documents/Wiki/work/html', 'auto_tags': 1},
	\ {'path': '~/Documents/Wiki/wtf_is_linux', 'path_html': '~/Documents/Wiki/wtf_is_linux/html', 'auto_tags': 1}
\ ]

let g:vimwiki_auto_header = 1
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_html_header_numbering = 2
let g:vimwiki_html_header_numbering_sym = '.'

let g:vimwiki_links_header_level = 2
let g:vimwiki_tags_header_level = 2
let g:vimwiki_toc_header_level = 2

call deoplete#custom#var('omni', 'input_patterns', { 'vimwiki': '\[\[\w*|\:\w+' })
" }}}

" vim: fdm=marker
