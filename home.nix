{ ... }:

let
  rev = "4205c91609d6309ebbcddfa675fc63937718c14b";
  homeManagerPath = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
    sha256 = "0aywqya116bj40qmhh6x0sz7v6iyb93rnvq93h5ifx4r9lww714j";
  };
in
  {
    imports = [
      (import (homeManagerPath) {}).nixos
    ];

    home-manager.users.minijackson = { ... }:
    {
      manual.manpages.enable = true;
    };
  }
