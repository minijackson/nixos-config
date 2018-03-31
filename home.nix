{ pkgs, ... }:

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
    };

    programs = {
      browserpass.enable = true;
      firefox.enable = true;
      pidgin.enable = true;
    };

    xdg.configFile."alacritty/alacritty.yml".source = ./dotfiles/alacritty.yml;
  };

}
