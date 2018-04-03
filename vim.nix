{ config, pkgs, ... }:

{

  imports = [
    ./theme.nix
  ];

  environment.systemPackages = with pkgs; [
    python27Packages.neovim python36Packages.neovim neovim-qt
    (neovim.override {

      configure = {

        customRC = with config.theme;
        ''
          let g:dominant_color = '${colors.dominant}'
        '' + builtins.readFile ./dotfiles/vimrc.vim;

        vam = {
          knownPlugins = vimPlugins // {

            tmux-complete = vimUtils.buildVimPluginFrom2Nix {
              name = "tmux-complete";
              src = fetchgit {
                url = "https://github.com/wellle/tmux-complete.vim";
                rev = "c71a00272f5142b2a05918d3c689459fc3dd8858";
                sha256 = "14rrwd2kh3bv7zah1yib85cbl43qv6nklswzdw1gla190gyhwfix";
              };
            };

            neco-syntax = vimUtils.buildVimPluginFrom2Nix {
              name = "neco-syntax";
              src = fetchgit {
                url = "https://github.com/Shougo/neco-syntax.git";
                rev = "98cba4a98a4f44dcff80216d0b4aa6f41c2ce3e3";
                sha256 = "1cjcbgx3h00g91ifgw30q5n97x4nprsr4kwirydws79fcs4vkgip";
              };
            };

            neco-vim = vimUtils.buildVimPluginFrom2Nix {
              name = "neco-vim";
              src = fetchgit {
                url = "https://github.com/Shougo/neco-vim.git";
                rev = "f5397c5e800d65a58c56d8f1b1b92686b05f4ca9";
                sha256 = "0yb7ja6qgrazszk4i01cwjj00j9vd43zs2r11b08iy8n10jnzr73";
              };
            };

            vim-unimpaired = vimUtils.buildVimPluginFrom2Nix {
              name = "vim-unimpaired";
              src = fetchgit {
                url = "https://github.com/tpope/vim-unimpaired.git";
                rev = "c77939c4aff30b2ed68deb1752400ec15f17c3a2";
                sha256 = "0qd9as008r2vycls48bfb163rp7dddw7l495xn4l1gl00sh79cxy";
              };
            };

          };

          pluginDictionaries = [
            # UI
            { name = "undotree"; }
            { name = "gruvbox"; }
            { name = "gitgutter"; }
            { name = "lightline-vim"; }

            # Motions
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
