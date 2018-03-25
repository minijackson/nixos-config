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
