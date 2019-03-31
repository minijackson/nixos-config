{ config, lib, pkgs, ... }:

{

  imports = [ ./tinc-secret.nix ];

  options.tinc  = with lib; {
    networkName = mkOption {
      type = types.str;
      description = "Name of the Mesh network";
    };

    hosts = mkOption {
      type = types.listOf types.str;
      description = "Lists of node names in the Mesh VPN";
    };

    extraConfig = mkOption {
      type = types.lines;
      description = "Extra Tinc configuration";
    };
  };

  config = {
    networking = {
      interfaces."tinc.${config.tinc.networkName}" = {
        #virtual = true;
        #virtualType = "tun";
        ipv4.addresses = [{ address = config.topology.myMeshAddress; prefixLength = 24; }];
      };
      firewall.allowedUDPPorts = [ 655 ];
      firewall.allowedTCPPorts = [ 655 ];
    };

    services.tinc.networks.${config.tinc.networkName} = {
      name = "${config.networking.hostName}";
      debugLevel = 3;

      extraConfig = config.tinc.extraConfig;

      hosts = with config.tinc;
      lib.genAttrs hosts (name: builtins.readFile (../res/tinc + "/${networkName}/hosts/${name}"));

    };
  };
}
