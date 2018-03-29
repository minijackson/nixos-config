{ config, pkgs, ... }:

{
  hardware  = {
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
    };

    # For Steam
    opengl.driSupport32Bit = true;

  };

  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };
}
