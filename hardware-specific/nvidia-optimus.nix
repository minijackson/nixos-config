{ pkgs, ... }:

{

  hardware.bumblebee.enable = false;

  services.xserver = {
    videoDrivers = [ "nvidiaBeta" ];
    libinput.enable = true;
    deviceSection = ''
      #Identifier "nvidia"
      #Driver "nvidia"
      BusID "1:0:0"
      Option "AllowEmptyInitialConfiguration"
    '';
    moduleSection = ''
      Load "modesetting"
    '';
  };

  boot.blacklistedKernelModules = [ "i915" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];

  # TODO: add these commands for when starting X

  # ${pkgs.xlibs.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
  # ${pkgs.xlibs.xrandr}/bin/xrandr --auto
}
