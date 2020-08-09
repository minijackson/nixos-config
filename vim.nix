{ config, pkgs, lib, ... }:

let myNeovim = (pkgs.neovim.override {
  configure = {

    customRC = with lib;
    (concatStringsSep
    "\n"
    (mapAttrsToList
    (variable: value: "let g:${variable} = ${value}")
    config.vim.variables))
    + "\n" + builtins.readFile ./dotfiles/vimrc.vim + config.vim.extraConfig;

      vam = with pkgs; {
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
          tmux-complete   = vimPluginFromGit "tmux-complete";

        };

        pluginDictionaries = [
              # UI
              { name = "undotree"; }
              { name = "gruvbox-community"; }
              { name = "gitgutter"; }
              { name = "lightline-vim"; }
              { name = "vim-dirvish"; }

              # Motions
              { name = "CamelCaseMotion"; }
              { name = "surround"; }
              { name = "targets-vim"; }

              # Frameworks
              { name = "deoplete-nvim"; }
              { name = "neosnippet"; }
              { name = "neosnippet-snippets"; }
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
              { name = "vim-pandoc"; }
              { name = "vim-pandoc-syntax"; }

              # Languages (but not programming languages)
              { name = "vim-grammarous"; }

              # Other
              { name = "tmux-complete"; }
              { name = "fugitive"; }
              { name = "rhubarb"; }
              { name = "repeat"; }
              { name = "vim-unimpaired"; }
              { name = "tabular"; }
              { name = "vimwiki"; }
              { name = "vim-abolish"; }

            ] ++ config.vim.extraPlugins;

      };

    };
  });
in {

  imports = [
    ./theme.nix
  ];

  options.vim = with lib; {

    variables = mkOption {
      type = types.attrsOf types.str;
      default = {
        dominant_color = "'${config.theme.colors.dominant}'";
        ripgrep_path = "'${pkgs.ripgrep}/bin/rg'";
        fd_path = "'${pkgs.fd}/bin/fd'";
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
    nixpkgs.overlays = let
      unstable = import <nixpkgs-unstable> {};
    in [
      (self: super: {
        inherit (unstable) gnvim vimPlugins neovim;
      })
    ];

    environment.systemPackages = with pkgs; [
      myNeovim
      (neovim-qt.override { neovim = myNeovim; })
      (gnvim.override { neovim = myNeovim; })
    ];

    environment.sessionVariables = {
      EDITOR = "nvim";
    };
  };

}
