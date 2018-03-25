{ config, pkgs, ... }:

{
  hardware  = {
    cpu.intel.updateMicrocode = true;

    pulseaudio = {
      enable = true;

      tcp = {
        enable = true;
        anonymousClients.allowedIpRanges = [ "127.0.0.1" "192.168.1.0/24" ];
      };

    };

    # For Steam
    opengl.driSupport32Bit = true;

  };

  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };
}
