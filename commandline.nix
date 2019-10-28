{ config, pkgs, lib, ... }:

with import ./lib/theme.nix { inherit lib; };
let
  dominantEscapeCode = fgEscapeCode config.theme.colors.dominant;

  shellScripts = {
    split-cue = ./scripts/standalone/split-cue.sh;
  };
in
{
  nixpkgs.overlays = let
    unstable = import <nixos-unstable> {};
  in [
    (self: super: {
      inherit (unstable) starship;
    })
  ];

  environment.shellAliases = {
    ll = "ls -l";
    e = "\${EDITOR}";
    cpr = "${pkgs.rsync}/bin/rsync -ah --inplace --info=progress2";
  };

  programs.bash = {
    enableCompletion = true;
    interactiveShellInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"

      PATH="${pkgs.pazi}/bin:$PATH"
      eval "$(pazi init bash)"
    '';
  };

  programs.zsh = {
    enable = true;

    interactiveShellInit = with lib;
    ''
      source "${pkgs.grml-zsh-config}/etc/zsh/zshrc"
      is4 && xsource "${pkgs.grml-zsh-config}/etc/zsh/keephack"

      PATH="${pkgs.pazi}/bin:$PATH"
      eval "$(pazi init zsh)"

      source "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

      alias ${concatStringsSep " "
        (mapAttrsToList
          (name: script: "${name}=\"${script}\"")
          shellScripts)}

      function () {
        local dominant_escape_code="${dominantEscapeCode}"
        local dim_fg_escape_code="${fgEscapeCode config.theme.colors.dimForeground}"

        ${builtins.readFile ./dotfiles/zshrc}
      }

      # Grml's ZSH config overrides less variables
      export ${concatStringsSep " "
        (mapAttrsToList
          (variable: value: "${variable}=\"${value}\"")
          config.programs.less.envVariables)}

      #eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    # otherwise it'll override the grml prompt
    promptInit = "";
    # Grml handles that, and supports cache (faster!!!)
    enableGlobalCompInit = false;

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "line" ];
    };

    shellAliases = {
      e = "\${(z)EDITOR}";
    };
  };

  users.defaultUserShell = pkgs.zsh;

  programs.less = {
    envVariables = {
      LESS_TERMCAP_mb = dominantEscapeCode;
      LESS_TERMCAP_md = dominantEscapeCode;
    };
  };

  security.sudo.extraConfig =
  let
    lectureFile = builtins.toFile "sudoers.lecture" ''
    [1m
         ${dominantEscapeCode}"Bee" careful    [34m__
           ${dominantEscapeCode}with sudo!    [34m// \
                         \\_/ [33m//
       [35m'''-.._.-'''-.._.. [33m-(||)(')
                         ''''[0m

    '';
  in
    ''
    Defaults lecture = always
    Defaults lecture_file = "${lectureFile}"
    '';

    home-manager.users.minijackson = { ... }:
    {
      xdg.configFile."starship.toml".text = ''
        [directory]
        fish_style_pwd_dir_length = 2
        style = "bold dimmed blue"

        [git_status]
        ahead = "^"
        behind = "v"
        deleted = "x"

        [jobs]
        symbol = "+ "

        [package]
        symbol = "version "
        style = "bold green"

        [rust]
        symbol = "rust "
        style = "bold dimmed yellow"

        [nix_shell]
        style = "bold blue"
      '';
    };
}
