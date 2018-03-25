{ config, pkgs, ... }:

{

  users.extraUsers.minijackson.packages = with pkgs; [
    alacritty
    arc-theme arc-icon-theme lxappearance-gtk3
    polkit_gnome
    xsel
    qutebrowser
    kodi mpv
    steam kodiPlugins.steam-launcher
    zathura
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbOptions = "eurosign:e";
    libinput.enable = true;

    displayManager = {
      slim.enable = true;
      slim.defaultUser = "minijackson";
      slim.theme =
        let path = builtins.fetchTarball "https://github.com/adi1090x/slim_themes/archive/master.tar.gz";
        in "${path}/themes/greeny_dark";

      sessionCommands = ''
        ${pkgs.xlibs.xrdb}/bin/xrdb -merge ${./dotfiles/Xresources}
      '';
    };

    desktopManager = {
      kodi.enable = true;
      xfce.enable = true;
      xfce.screenLock = "xscreensaver";
      #gnome3.enable = true;

      default = "xfce";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dunst
        feh
        i3lock
        (polybar.override {
          i3GapsSupport = true;
          mpdSupport = true;
        })
        rofi
      ];
      configFile =
        let extraConfig = ''
          exec feh --bg-fill "$(find ${./res/wallpapers} -type f -print0 | shuf -zn1)"
          exec polybar --config=${./dotfiles/polybar} main
        '';
        in builtins.toFile "i3config" ''
          ${builtins.readFile ./dotfiles/i3}
          ${extraConfig}
        '';
    };

  };

  fonts = {
    fonts = with pkgs; [ fira-mono dejavu_fonts unifont siji ];

    fontconfig = {
      ultimate.enable = true;

      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Fira Mono" ];
      };
    };

  };

}
