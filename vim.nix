{ config, pkgs, lib, ... }:

{

  imports = [
    ./theme.nix
  ];

  options.vim = with lib; {

    variables = mkOption {
      type = types.attrsOf types.str;
      default = {
        dominant_color = "'${config.theme.colors.dominant}'";
        ripgrep_path = "'${pkgs.ripgrep}/bin/rg'";
      };
      description = ''
        Extra global variables to add at the beginning of the vim configuration.

        Remember to escape strings with single-quotes.
      '';
    };

    extraPlugins = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [];
      description = "Names of extra plugins to add";
    };

    extraRepoPlugins = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [];
      description = "Names of extra plugins to add that are present in the local repository";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lines to add at the end of the vim configuration";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      python27Packages.neovim python36Packages.neovim neovim-qt
      (neovim.override {

        configure = {

          customRC = with lib;
            (concatStringsSep
              "\n"
              (mapAttrsToList
                (variable: value: "let g:${variable} = ${value}")
                config.vim.variables))
            + "\n" + builtins.readFile ./dotfiles/vimrc.vim + config.vim.extraConfig;

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
              vim-dirvish     = vimPluginFromGit "vim-dirvish";
              vim-unimpaired  = vimPluginFromGit "vim-unimpaired";

            };

            pluginDictionaries = [
              # UI
              { name = "undotree"; }
              { name = "gruvbox"; }
              { name = "gitgutter"; }
              { name = "lightline-vim"; }
              { name = "vim-dirvish"; }

              # Motions
              { name = "CamelCaseMotion"; }
              { name = "surround"; }
              { name = "targets-vim"; }

              # Frameworks
              { name = "deoplete-nvim"; }
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

              # Languages (but not programming languages)
              { name = "vim-grammarous"; }

              # Other
              { name = "tmux-complete"; }
              { name = "fugitive"; }
              { name = "rhubarb"; }
              { name = "repeat"; }
              { name = "vim-unimpaired"; }

            ] ++ config.vim.extraPlugins;

          };

        };
      })
    ];

    environment.sessionVariables = {
      EDITOR = "nvim";
    };
  };

}
