{ config, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.allowPing = true;

  networking.networkmanager = {
    enable = true;
    useDnsmasq = true;
    insertNameservers = [
      # ns2.he.de
      "172.104.136.243" "2a01:7e01::f03c:91ff:febc:322"
      # ns1.ti.ch
      "31.3.135.232"
      # ns2.hau.fr
      "188.165.200.156"
      # ns1.pra.cz
      "51.254.25.115" "2001:41d0:2:73d4::125"
    ];

  };

  services.dnsmasq = {
    enable = false;
    extraConfig = ''
    cache-size=1000
    '';
    servers = [
      # ns2.he.de
      "172.104.136.243" "2a01:7e01::f03c:91ff:febc:322"
      # ns1.ti.ch
      "31.3.135.232"
      # ns2.hau.fr
      "188.165.200.156"
      # ns1.pra.cz
      "51.254.25.115" "2001:41d0:2:73d4::125"
      # box
      "192.168.1.1"
    ];
  };

}
