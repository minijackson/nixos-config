{ pkgs, ... }:

let
  myPackages = import ../packages { inherit pkgs; };
in {

  imports = [
    ../vim.nix
  ];

  vim = {

    extraPlugins = [
      { name = "LanguageClient-neovim"; }

      # C / C++
      { name = "neoinclude"; }
    ];

    extraConfig = let
      cqueryPath = "${myPackages.cquery}/bin/cquery";
      clangGlibcFlags = "['-idirafter', '${pkgs.glibc.dev}/include']";
      clangCxxStdlibFlags = "split(system('bash -c \"echo -n \\\"${pkgs.clang.default_cxx_stdlib_compile}\\\"\"'))";
      clangCxxFlagsJson = "json_encode(${clangGlibcFlags} + ${clangCxxStdlibFlags})";
      clangCFlagsJson   = "json_encode(${clangGlibcFlags})";
    in ''
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
            \ 'cpp' : [ '${cqueryPath}', '--init={"extraClangArguments": ' . ${clangCxxFlagsJson} . ', "cacheDirectory": "/tmp/' . $USER . '/cquery"}' ],
            \ 'c'   : [ '${cqueryPath}', '--init={"extraClangArguments": ' . ${clangCFlagsJson}   . ', "cacheDirectory": "/tmp/' . $USER . '/cquery"}' ],
            \ }
    '';

  };

}
