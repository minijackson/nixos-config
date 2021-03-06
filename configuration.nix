# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./boot.nix
      ./commandline.nix
      ./hardware-bis.nix
      ./home.nix
      ./host.nix
      ./networking.nix
      ./tmux.nix
      ./topology-secret.nix
      ./vim.nix
      ./x.nix
    ];

  # Select internationalisation properties.
  i18n = {
    #defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = { LC_TIME = "en_DK.UTF-8"; };
  };

  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-d22n";
    colors = [ "282a2e" "a54242" "8c9440" "de935f" "5f819d" "85678f" "5e8d87" "707880" "373b41" "cc6666" "b5bd68" "f0c674" "81a2be" "b294bb" "8abeb7" "c5c8c6" ];
    keyMap = "fr";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim tmux
    ripgrep file progress psmisc lsof nethogs
    fd tree ncdu
    lm_sensors hddtemp smartmontools
    elinks
    wipe
    gnupg
    nix-prefetch-scripts
    shellcheck
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.ccache.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Update the mlocate db daily
  services.locate.enable = true;

  services.gnome3.gnome-keyring.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.mfcl2720dwcupswrapper ];
  };

  services.journald.rateLimitBurst = 1000;

  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.minijackson = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "users" "wheel" "networkmanager" "lp" "video" "input" "adbusers" ];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmyjB5yuU8GK3ZVFznELVEwXN7zzjQJcPYZ89YCGTANjPHpHxZv5R9/kgjTtIKrqqHdTvfr8V8sao9Nr7PhtcV9UywrFn+kplyGf9WDl2oDF9eZprX3beR9zwDj/YIcFRx3wXk4JK/ioZJjcVZ3+xWPixiFplvHIyMsTjKfgRplntHpvoyLM8vURjLOCdPr6SRPReVXuSR2DRlVO7q7y+4FwA1FKAndg9YACoM1g2bEJ6eGyCPp2kFde+GvMv1y6FlBS1OFddGmBpUJzJ4mQ4ebqDVFsKQMx1xCkiz0l7tfVpXqXToHF+baTESEKbC4654PunD99BC0J4otHKrerdmX0HdTgHKtAnslSwRD5NZVAojk/CR3DiSQYFSO9OhFVjHNQsc1zpoKPtJYMe1ax3pcvc+XLCrKLUdHH8x9rVGefZXwIyLrrGrB7fVlyIyX7j04dNALQZiuFOKCInaYypVLHLy0k+buhQlVqKCS6N1xP5O6JiWUKXFYYyoRmSoX9+bfPiwsMrPL+rYXkee0K67BI1NiFAYPmdFFM0jtdFaYuvgEAWw7b9WyWyO/JAdHRwtlqfAqraPBrb4sldvQfLBm8RdORBYMaVbg4EUKMOJjIeAAK+7xWPtg2XeJNnsje/IsWaVXIBx2IAC50uAnIZ/ksw5lyAZP+HyGIHhCAQChQ== minijackson@riseup.net"];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ./packages) ];
  };

  nix = {
    binaryCaches = [ "https://hydra.huh.gdn/" "https://cache.nixos.org/" ];
    binaryCachePublicKeys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "hydra.huh.gdn-1:MZDmrn/p0MxBN2ScynKJd7v6TVC7vxRTGK8E9vxkxEk="
    ];

    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 30d";
    };
  };

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
