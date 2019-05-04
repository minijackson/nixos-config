{ nixpkgs ? import <nixpkgs>, ... }:

let
  pkgs = nixpkgs {
    config = { };
    overlays = [ (import ./overlay.nix) ];
  };
in
  pkgs.my_package
