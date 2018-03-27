# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./boot.nix
      ./hardware-bis.nix
      ./home.nix
      ./host.nix
      ./networking.nix
      ./shell.nix
      ./tmux.nix
      ./vim.nix
      ./x.nix
    ];

  # Select internationalisation properties.
  i18n = {
    consolePackages = with pkgs; [ terminus_font ];
    consoleFont = "ter-d22n";
    consoleColors = [ "282a2e" "a54242" "8c9440" "de935f" "5f819d" "85678f" "5e8d87" "707880" "373b41" "cc6666" "b5bd68" "f0c674" "81a2be" "b294bb" "8abeb7" "c5c8c6" ];
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim tmux htop ripgrep fd tree lsof
    wipe
    git
    nox nix-prefetch-scripts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Update the mlocate db daily
  services.locate.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.minijackson = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "users" "wheel" "networkmanager" "lp" "video" "input" ];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmyjB5yuU8GK3ZVFznELVEwXN7zzjQJcPYZ89YCGTANjPHpHxZv5R9/kgjTtIKrqqHdTvfr8V8sao9Nr7PhtcV9UywrFn+kplyGf9WDl2oDF9eZprX3beR9zwDj/YIcFRx3wXk4JK/ioZJjcVZ3+xWPixiFplvHIyMsTjKfgRplntHpvoyLM8vURjLOCdPr6SRPReVXuSR2DRlVO7q7y+4FwA1FKAndg9YACoM1g2bEJ6eGyCPp2kFde+GvMv1y6FlBS1OFddGmBpUJzJ4mQ4ebqDVFsKQMx1xCkiz0l7tfVpXqXToHF+baTESEKbC4654PunD99BC0J4otHKrerdmX0HdTgHKtAnslSwRD5NZVAojk/CR3DiSQYFSO9OhFVjHNQsc1zpoKPtJYMe1ax3pcvc+XLCrKLUdHH8x9rVGefZXwIyLrrGrB7fVlyIyX7j04dNALQZiuFOKCInaYypVLHLy0k+buhQlVqKCS6N1xP5O6JiWUKXFYYyoRmSoX9+bfPiwsMrPL+rYXkee0K67BI1NiFAYPmdFFM0jtdFaYuvgEAWw7b9WyWyO/JAdHRwtlqfAqraPBrb4sldvQfLBm8RdORBYMaVbg4EUKMOJjIeAAK+7xWPtg2XeJNnsje/IsWaVXIBx2IAC50uAnIZ/ksw5lyAZP+HyGIHhCAQChQ== minijackson@riseup.net"];

    packages = with pkgs; [ ffmpeg pass gnupg ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
