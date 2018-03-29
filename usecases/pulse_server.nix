{ config, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" "192.168.1.0/24" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 4713 ];
}
