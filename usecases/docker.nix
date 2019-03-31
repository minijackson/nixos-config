{ ... }:

{
  virtualisation.docker = {
    enable = true;
  };

  users.users.minijackson.extraGroups = [ "docker" ];
}
