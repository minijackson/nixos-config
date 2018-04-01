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
  };

  home-manager.users.minijackson = { ... }:
  {
    programs.beets.settings = {
      plugins = "convert edit fromfilename mbsync missing mpdupdate the";
      paths = {
        default   = "%the{$albumartist}/%the{$album}%aunique{}/$track $title";
        singleton = "Non-Album/%the{$artist}/%the{$title}";
        comp      = "Compilations/%the{$album}%aunique{}/$track $title";
      };
    };

    xdg.configFile."ncmpcpp/config".source = ../dotfiles/ncmpcpp;

  };

  users.extraUsers.minijackson.packages = [
    (pkgs.ncmpcpp.override {
      outputsSupport = true;
      visualizerSupport = true;
    })
  ];


}
