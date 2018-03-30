{ ... }:

let
  common-home-configuration = {
    manual.manpages.enable = true;
    programs.git = {
      enable = true;
      userEmail = "minijackson@riseup.net";
      userName = "Minijackson";
    };
  };
in
{
  imports = [
    ./home-manager/nixos
  ];

  home-manager.users.root = { ... }:
  common-home-configuration // {
  };

  home-manager.users.minijackson = { ... }:
  common-home-configuration // {
  };
}
