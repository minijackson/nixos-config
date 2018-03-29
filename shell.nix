{ config, pkgs, lib, ... }:

with import ./lib/theme.nix { inherit lib; };
let
  dominantEscapeCode = fgEscapeCode config.theme.colors.dominant;
in
{
  environment.systemPackages = with pkgs; [ zsh grml-zsh-config zsh-completions ];

  environment.shellAliases = {
    ll = "ls -l";
    e = "\${EDITOR}";
  };

  programs.bash.enableCompletion = true;
  programs.zsh = {
    enable = true;

    interactiveShellInit = with lib;
    ''
      source "${pkgs.grml-zsh-config}/etc/zsh/zshrc"

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
    '';
    promptInit = ""; # otherwise it'll override the grml prompt

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "cursor" "line" ];
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

}
