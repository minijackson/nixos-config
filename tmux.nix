{ config, pkgs, ... } :

{

  imports = [ ./theme.nix ];

  programs.tmux = {
    enable = true;
    shortcut = "q";
    escapeTime = 10;
    keyMode = "vi";
    terminal = "screen-256color";
    historyLimit = 50000;

    extraTmuxConf = with config.theme;
    ''
      # Be faster switching windows
      bind C-n next-window
      bind C-p previous-window

      bind C-y run "${pkgs.tmux}/bin/tmux show-buffer > /dev/null 2>&1 && ${pkgs.tmux}/bin/tmux show-buffer | ${pkgs.xsel}/bin/xsel -ib"

      # Force true colors
      set-option -ga terminal-overrides ",*:Tc"

      set-option -g mouse on
      set-option -g focus-events on

      # Stay in same directory when split
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # Colorscheme

      set-option -g status-style 'fg=${colors.dimForeground}, bg=${colors.background}'

      set-option -g window-status-current-fg '${colors.dominant}'

      set-option -g pane-border-fg '${colors.background}'
      set-option -g pane-active-border-fg '${colors.dominant}'

      set-option -g message-style 'fg=${colors.background}, bg=${colors.dimForeground}'

      set-option -g mode-style    'fg=${colors.background}, bg=${colors.dominant}'

      set-option -g display-panes-active-colour '${colors.dominant}'
      set-option -g display-panes-colour '${colors.dimForeground}'

      set-option -g clock-mode-colour '${colors.dominant}'
    '';
  };
}
