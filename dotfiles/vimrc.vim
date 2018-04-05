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

" LanguageClient {{{

let g:LanguageClient_autoStart = 1
augroup LanguageClient_config
	autocmd!
	autocmd User LanguageClientStarted nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
	autocmd User LanguageClientStarted nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
	autocmd User LanguageClientStarted nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
	autocmd User LanguageClientStarted setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()

	autocmd User LanguageClientStarted nnoremap <silent> <Leader>sr :call LanguageClient_textDocument_references()<CR>
	autocmd User LanguageClientStarted nnoremap <silent> <Leader>ss :call LanguageClient_textDocument_documentSymbol()<CR>
augroup END

let g:LanguageClient_serverCommands = {
			\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
			\ 'cpp' : [ g:cquery_path, '--init={"extraClangArguments": ' . g:clang_cxx_flags_json . ', "cacheDirectory": "/tmp/' . $USER . '/cquery"}' ],
			\ 'c'   : [ g:cquery_path, '--init={"extraClangArguments": ' . g:clang_c_flags_json   . ', "cacheDirectory": "/tmp/' . $USER . '/cquery"}' ],
			\ }

" }}}

set completefunc=syntaxcomplete#Complete

let g:deoplete#enable_at_startup = 1

" vim: fdm=marker
