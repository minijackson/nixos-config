{ config, pkgs, ... }:

{

  users.extraUsers.minijackson.packages = with pkgs; [
    alacritty
    polkit_gnome
    gnome3.dconf gnome3.nautilus
    gnome3.gucharmap
    kdeconnect
    xsel
    qutebrowser
    kodi mpv
    calibre
    gnome3.evolution
    steam kodiPlugins.steam-launcher
    zathura
  ];

  # 8080 for Kodi remote control
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # For KDEConnect
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

  home-manager.users.minijackson = { config, ... }:
  {
    systemd.user.services.kdeconnect = {
      Unit = {
        Description = "Start the KDEConnect indicator";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        # Source /etc/profile before to have the right QT_PLUGIN_PATH environment vairables and such
        ExecStart = "${pkgs.bash}/bin/sh -c 'source /etc/profile && ${pkgs.kdeconnect}/bin/kdeconnect-indicator'";
      };
    };
  };

  security.pam.services.slim.enableGnomeKeyring = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "oss";
    xkbOptions = "eurosign:e";

    libinput = {
      enable = true;
      disableWhileTyping = true;
    };

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
        feh
        i3lock
        rofi
      ];
      #configFile =
      #  let extraConfig = ''
      #    exec feh --bg-fill "$(find ${./res/wallpapers} -type f -print0 | shuf -zn1)"
      #    exec polybar --config=${./dotfiles/polybar} main
      #  '';
      #  in builtins.toFile "i3config" ''
      #    ${builtins.readFile ./dotfiles/i3}
      #    ${extraConfig}
      #  '';
    };

  };

  fonts = {
    fonts = with pkgs; [ fira-mono dejavu_fonts freefont_ttf liberation_ttf noto-fonts-cjk unifont siji ];

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
