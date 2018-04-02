{ config, pkgs, ... }:

let
  transmission-rpc-port = 9091;
  transmission-peer-port = 51413;
in
  {
    imports = [
      ./torrent-secret.nix
    ];

    services.transmission = {
      enable = true;
      settings = {
        download-dir = "/var/lib/transmission/Downloads";
        incomplete-dir = "/var/lib/transmission/.incomplete";
        incomplete-dir-enabled = true;

        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-port = transmission-rpc-port;
        rpc-authentication-required = true;
        rpc-username = "transmission";
        # Password set in torrent-secret.nix

        blocklist-enabled = true;
        blocklist-url = "http://list.iblocklist.com/?list=gyisgnzbhppbvsphucsw&fileformat=p2p&archiveformat=gz";

        trash-original-torrent-files = true;

        # 2 = Required
        encryption = 2;

        peer-port = transmission-peer-port;
        peer-socket-tos = "lowcost";

        download-queue-size = 10;

        ratio-limit = 2.0;
        ratio-limit-enabled = true;
      };
    };

    services.radarr.enable = true;
    services.sonarr.enable = true;
    services.jackett.enable = true;

    users.users.radarr.extraGroups = [ "transmission" ];
    users.users.sonarr.extraGroups = [ "transmission" ];

    users.users.minijackson.extraGroups = [ "transmission" "sonarr" "radarr" ];

    networking.firewall.allowedTCPPorts = [
      transmission-rpc-port transmission-peer-port
      # Sonarr WebUI
      8989
      # Radarr WebUI
      7878
      # Jackett WebUI
      9117
    ];
  }
