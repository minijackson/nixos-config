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

          };

          pluginDictionaries = [
            # UI
            { name = "undotree"; }
            { name = "gruvbox"; }
            { name = "gitgutter"; }

            # Motions
            { name = "surround"; }

            # Frameworks
            { name = "deoplete-nvim"; }
            { name = "LanguageClient-neovim"; }
            { name = "neoformat"; }

            # Languages
            { name = "vim-polyglot"; }
            { name = "editorconfig-vim"; }

            # Other
            { name = "tmux-complete"; }
          ];

        };

      };
    })
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

}
