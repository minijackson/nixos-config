{ config, pkgs, lib, ... }:

let
  nameServers = [
    # ns2.he.de
    "172.104.136.243" "2a01:7e01::f03c:91ff:febc:322"
    # ns10.fr.dns.opennic.glue
    "87.98.175.85" "2001:41d0:2:73d4::100"
    # ns12.fr.dns.opennic.glue
    "5.135.183.146"
    # ns1.pra.cz
    "51.254.25.115" "2001:41d0:2:73d4::125"
    # ns1.ti.ch
    "31.3.135.232"
    # ns2.hau.fr
    "188.165.200.156"
  ];
in {

  networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.allowPing = true;

  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";
    appendNameservers = nameServers;

    dynamicHosts = {
      enable = true;
      hostsDirs.server = {};
    };

    wifi.macAddress = "8e:00:2f:29:5c:39";

  };

  # TODO: move that into Tinc and add all hosts
  networking.extraHosts = ''
    ${config.topology.serverAddress} huh.lan
  '';

  environment.etc = {
    "NetworkManager/dnsmasq.d/nameServers.conf".text =
      lib.concatMapStrings (server: ''
        server=${server}
      '') nameServers;

    "NetworkManager/dnsmasq.d/local.conf".text = ''
      local=/lan/
      addn-hosts=/etc/hosts
    '';
  };

  services.dnsmasq = {
    enable = false;
    extraConfig = ''
    cache-size=1000
    '';
    servers = nameServers;
  };

}
