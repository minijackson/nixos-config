{ config, pkgs, ... } :

{
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    keyMode = "vi";
    terminal = "screen-256color";

    extraTmuxConf = ''
      set-option -g mouse
      set-option -g history-limit 50000
      set-option -g focus-events on

      # Colorscheme

      set-option -g status-bg '#282828'
      set-option -g status-fg '#928374'

      set-option -g window-status-current-fg '#b8bb26'

      set-option -g pane-border-fg '#282828'
      set-option -g pane-active-border-fg '#928374'

      set-option -g message-bg '#928374'
      set-option -g message-fg '#282828'
    '';
  };
}
