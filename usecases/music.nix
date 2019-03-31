{ config, pkgs, ... }:

{

  hardware.pulseaudio.tcp.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "/home/minijackson/Music";
    user = "minijackson";
    group = "users";

    extraConfig = ''
      audio_output {
        type   "pulse"
        name   "PulseAudio"
        server "127.0.0.1"
      }

      audio_output {
        type   "fifo"
        name   "Fifo"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';

    startWhenNeeded = true;
  };

  home-manager.users.minijackson = { ... }:
  {
    programs.beets.settings = {
      plugins = "convert edit fromfilename mbsync mbsubmit missing mpdupdate the fetchart random zero";
      paths = {
        default   = "%the{$albumartist}/%the{$album}%aunique{}/$track $title";
        singleton = "Non-Album/%the{$artist}/%the{$title}";
        comp      = "Compilations/%the{$album}%aunique{}/$track $title";
      };
      zero.fields = "comments";
    };

    xdg.configFile."ncmpcpp/config".source = ../dotfiles/ncmpcpp;

    xsession.windowManager.i3.config.keybindings = {
      "KP_Left"  = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc prev";
      "KP_Begin" = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc toggle";
      "KP_Right" = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc next";
      "KP_Up"    = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc stop";

      "XF86AudioPlay" = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc toggle";
      "XF86AudioNext" = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc next";
      "XF86AudioPrev" = "exec --no-startup-id ${pkgs.mpc_cli}/bin/mpc prev";

      "KP_Home" = let
        choose_album = pkgs.substituteAll {
          src = ../scripts/choose_album.sh;
          isExecutable = true;

          inherit (pkgs) sqlite mpc_cli rofi;
        };
      in "exec --no-startup-id ${choose_album}";

      "KP_Prior" = let
        choose_artist = pkgs.substituteAll {
          src = ../scripts/choose_artist.sh;
          isExecutable = true;

          inherit (pkgs) mpc_cli rofi;
        };
      in "exec --no-startup-id ${choose_artist}";

      "KP_End" = let
        random_albums = pkgs.substituteAll {
          src = ../scripts/random_albums.sh;
          isExecutable = true;

          inherit (pkgs) mpc_cli beets;
        };
      in "exec --no-startup-id ${random_albums}";

    };

  };

  users.extraUsers.minijackson.packages = [
    (pkgs.ncmpcpp.override {
      outputsSupport = true;
      visualizerSupport = true;
    })
  ];


}
