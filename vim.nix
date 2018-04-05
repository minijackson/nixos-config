{ config, pkgs, ... }:

let
  myPackages = import ./packages { inherit pkgs; };
in {

  imports = [
    ./theme.nix
  ];

  environment.systemPackages = with pkgs; [
    python27Packages.neovim python36Packages.neovim neovim-qt
    (neovim.override {

      configure = {

        customRC = with config.theme;
        ''
          " Colors
          let g:dominant_color = '${colors.dominant}'

          " Executable paths
          let g:cquery_path = '${myPackages.cquery}/bin/cquery'

          let g:clang_glibc_flags = ["-idirafter", "${pkgs.glibc.dev}/include"]
          let g:clang_cxx_stdlib_flags = split(system('bash -c "echo -n \"${pkgs.clang.default_cxx_stdlib_compile}\""'))

          let g:clang_cxx_flags_json = json_encode(g:clang_cxx_stdlib_flags + g:clang_glibc_flags)
          let g:clang_c_flags_json   = json_encode(g:clang_glibc_flags)
        '' + builtins.readFile ./dotfiles/vimrc.vim;

        vam = {
          knownPlugins = let

            releaseInfo = pluginName: builtins.fromJSON (builtins.readFile (./packages/vim-plugins + "/${pluginName}.json"));

            vimPluginFromGit = pluginName: vimUtils.buildVimPluginFrom2Nix {
              name = pluginName;
              src = fetchgit {
                inherit (releaseInfo pluginName) url rev sha256;
              };
            };

          in vimPlugins // {

            CamelCaseMotion = vimPluginFromGit "CamelCaseMotion";
            deoplete-zsh    = vimPluginFromGit "deoplete-zsh";
            neco-syntax     = vimPluginFromGit "neco-syntax";
            neco-vim        = vimPluginFromGit "neco-vim";
            tmux-complete   = vimPluginFromGit "tmux-complete";
            vim-unimpaired  = vimPluginFromGit "vim-unimpaired";

          };

          pluginDictionaries = [
            # UI
            { name = "undotree"; }
            { name = "gruvbox"; }
            { name = "gitgutter"; }
            { name = "lightline-vim"; }

            # Motions
            { name = "CamelCaseMotion"; }
            { name = "surround"; }
            { name = "targets-vim"; }

            # Frameworks
            { name = "deoplete-nvim"; }
            { name = "LanguageClient-neovim"; }
            { name = "neoformat"; }
            { name = "ctrlp"; }
            # Syntax generic completion for deoplete
            { name = "neco-syntax"; }

            # Languages
            { name = "vim-polyglot"; }
            { name = "editorconfig-vim"; }
            # Vim completion for deoplete
            { name = "neco-vim"; }
            { name = "deoplete-zsh"; }

            # C / C++
            { name = "neoinclude"; }

            # Other
            { name = "tmux-complete"; }
            { name = "fugitive"; }
            { name = "repeat"; }
            { name = "vim-unimpaired"; }
          ];

        };

      };
    })
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

}
