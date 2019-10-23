{ pkgs, ... }:

{

  imports = [
    ../vim.nix
  ];

  vim = {

    extraPlugins = [
      { name = "LanguageClient-neovim"; }

      # C / C++
      { name = "neoinclude"; }

      # Elixir
      { name = "alchemist-vim"; ft_regex = "^elixir|erlang\$"; }
    ];

    extraConfig = let
      cclsPath = "${pkgs.ccls}/bin/ccls";
      clangdPath = "${pkgs.libclang}/bin/clangd";
      clangGlibcFlags = "['-idirafter', '${pkgs.glibc.dev}/include']";
      clangCxxStdlibFlags = "split(system('bash -c \"echo -n \\\"${pkgs.clang.default_cxx_stdlib_compile}\\\"\"'))";
      #clangCxxFlagsJson = "json_encode(${clangGlibcFlags} + ${clangCxxStdlibFlags})";
      clangCxxFlagsJson = "json_encode(${clangCxxStdlibFlags})";
      clangCFlagsJson   = "json_encode(${clangGlibcFlags})";

      pylsPath = "${pkgs.python37Packages.python-language-server}/bin/pyls";
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
            \ 'rust':   ['rustup', 'run', 'stable', 'rls'],
            \ 'cpp' :   [ '${cclsPath}' ],
            \ 'c'   :   [ '${cclsPath}' ],
            \ 'python': [ '${pylsPath}' ],
            \ }
    '';
            #\ 'cpp' : [ '${cclsPath}', '--init={"extraClangArguments": ' . ${clangCxxFlagsJson} . ', "cacheDirectory": "/tmp/' . $USER . '/ccls"}' ],
            #\ 'c'   : [ '${cclsPath}', '--init={"extraClangArguments": ' . ${clangCFlagsJson}   . ', "cacheDirectory": "/tmp/' . $USER . '/ccls"}' ],

  };

  nixpkgs.overlays = let
    unstable = import <nixos-unstable> {};
  in [
    (self: super: {
      inherit (unstable) ccls;
      inherit (unstable.llvmPackages_latest) libclang;
    })
  ];

  users.extraUsers.minijackson.packages = with pkgs; [
    gdb rr
    beam.packages.erlangR20.elixir
    man-pages
  ];

  programs.zsh.interactiveShellInit = ''
    (( $+commands[rustc] )) && fpath+="$(rustc --print sysroot)/share/zsh/site-functions"
  '';

  documentation.dev.enable = true;

  boot.kernel.sysctl = {
    # For RR
    "kernel.perf_event_paranoid" = 1;
  };

  home-manager.users.minijackson = { config, ... }:
  {
    home.file.".clang-format".source = ../dotfiles/clang-format.yml;
  };

}
