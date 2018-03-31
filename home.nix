{ config, pkgs, ... }:

let
  common-home-configuration = {
    manual.manpages.enable = true;
    programs.git = {
      enable = true;
      userEmail = "minijackson@riseup.net";
      userName = "Minijackson";
    };
  };
in
{
  imports = [
    ./home-manager/nixos
    ./theme.nix
  ];

  users.extraUsers.minijackson.packages = with pkgs; [
    pass
    tmuxp
    tokei
    neofetch
    ffmpeg beets mpv youtube-dl pavucontrol
    pandoc poppler_utils
    rr rtags
  ];

  home-manager.users.root = { ... }:
  common-home-configuration // {
  };

  home-manager.users.minijackson = { ... }:
  common-home-configuration // {

    services = {
      udiskie.enable = true;
      redshift = {
        enable = true;
        latitude = "48.864716";
        longitude = "2.349014";
      };
      dunst = {
        enable = true;
        settings = with config.theme.colors;
        {
          global = {
            geometry = "300x5-30+50";

            format = "<b>%a</b>: %s\n%b";
            alignment = "center";
            word_wrap = "yes";
            stack_duplicates = "yes";

            frame_width = 1;
            frame_color = dimForeground;
            foreground = foreground;
            padding = 30;
            horizontal_padding = 20;
          };
          urgency_low = {
            background = background;
          };
          urgency_normal = {
            background = background;
          };
          urgency_critical = {
            background = background;
          };
        };
      };
    };

    programs = {
      browserpass.enable = true;
      firefox.enable = true;
      pidgin.enable = true;
    };

    xdg.configFile."alacritty/alacritty.yml".source = ./dotfiles/alacritty.yml;

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.arc-icon-theme;
        name = "Arc";
      };
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Darker";
      };
    };
  };

}
