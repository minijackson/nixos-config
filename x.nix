{ config, pkgs, ... }:

{

  users.extraUsers.minijackson.packages = with pkgs; [
    qt5.qtwayland
    alacritty
    polkit_gnome
    gnome3.dconf gnome3.nautilus gnome3.file-roller
    gnome3.gucharmap
    kdeconnect
    xsel
    qutebrowser opera
    kodi #mpv
    calibre
    gnome3.evolution
    #steam kodiPlugins.steam-launcher
    zathura
  ];

  # Uncomment when using UPnP / DNLA
  #networking.firewall.enable = false;

  # 8080 for Kodi remote control
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # For KDEConnect
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

  home-manager.users.minijackson = { config, ... }:
  {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  security.pam.services.slim.enableGnomeKeyring = true;

  services.gnome3.evolution-data-server.enable = true;

  services.gnome3.gvfs.enable = true;

  nixpkgs.config.kodi = {
    enableVFSSFTP = true;
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [ swaylock swayidle xwayland ];
    extraSessionCommands = ''
      unset GDK_PIXBUF_MODULE_FILE
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

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
      slim.enable = false;
      slim.defaultUser = "minijackson";
      #slim.theme =
      #  let path = builtins.fetchTarball "https://github.com/adi1090x/slim_themes/archive/master.tar.gz";
      #  in "${path}/themes/greeny_dark";

      sessionCommands = ''
        ${pkgs.xlibs.xrdb}/bin/xrdb -merge ${./dotfiles/Xresources}
      '';
    };

    desktopManager = {
      kodi.enable = true;
      xfce.enable = true;
      #xfce.screenLock = "xscreensaver";
      #gnome3.enable = true;

      default = "xfce";
    };

    wacom.enable = true;

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
    fonts = with pkgs; [ fira-mono dejavu_fonts freefont_ttf liberation_ttf noto-fonts-cjk unifont siji font-awesome_5 ];

    fontconfig = {
      ultimate.enable = true;

      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Fira Mono" ];
      };
    };

  };

  xdg.sounds.enable = true;

}
