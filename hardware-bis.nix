{ config, pkgs, ... }:

{
  hardware  = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;

    pulseaudio = {
      enable = true;
      # More "audiophile" settings
      daemon.config = {
        default-sample-format = "s32le";
        # Not setting to 192kHz because it's "considered harmful":
        # https://people.xiph.org/~xiphmont/demo/neil-young.html
        default-sample-rate = 96000;
        # Most movies are at 48kHz
        alternate-sample-rate = 48000;
        resample-method = "speex-float-7";
      };
      extraConfig = ''
        load-module module-equalizer-sink
        load-module module-dbus-protocol
      '';
    };

    opengl = {
      # For Steam
      driSupport32Bit = true;

      extraPackages = with pkgs; [ (vaapiIntel.override { enableHybridCodec = true; }) libvdpau-va-gl vaapiVdpau intel-ocl intel-media-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ (vaapiIntel.override { enableHybridCodec = true; }) libvdpau-va-gl vaapiVdpau ];
    };

  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  services.fwupd.enable = true;
}
