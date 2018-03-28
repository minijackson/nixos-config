{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ zsh grml-zsh-config zsh-completions ];

  environment.shellAliases = {
    ll = "ls -l";
    e = "\${EDITOR}";
  };

  programs.bash.enableCompletion = true;
  programs.zsh = {
    enable = true;

    interactiveShellInit = ''
      # Use the dominant color in the prompt
      dominant="${config.theme.colors.dominant}"
      dominant_red="$((16#''${dominant:1:2}))"
      dominant_green="$((16#''${dominant:3:2}))"
      dominant_blue="$((16#''${dominant:5:2}))"

      # In the username item for non-root, in the host item for root
      if [ "$EUID" -ne 0 ]; then
        zstyle ':prompt:grml:left:items:user' pre "%{[38;2;''${dominant_red};''${dominant_green};''${dominant_blue}m%}%B"
      else
        zstyle ':prompt:grml:left:items:host' pre "%{[38;2;''${dominant_red};''${dominant_green};''${dominant_blue}m%}"
        zstyle ':prompt:grml:left:items:host' post "%f"
      fi

      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

      bindkey -v
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
}
