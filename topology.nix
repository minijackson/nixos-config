{ lib, ... }:

with lib;

{
  options.topology = {

    serverAddress = mkOption {
      type = types.str;
      description = "The IP address of the personal server";
    };

    myMeshAddress = mkOption {
      type = types.str;
      description = "The IP address of the host on the mesh VPN interface";
    };

  };
}
