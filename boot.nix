{ config, pkgs, ... }:

{

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 5;
    "vm.dirty_background_ratio" = 4;
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 1048576;
  };

}
