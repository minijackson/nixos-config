{ ... }:

{
  imports = [
    ./home-manager/nixos
  ];

  home-manager.users.minijackson = { ... }:
  {
    manual.manpages.enable = true;
  };
}
