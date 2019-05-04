{ nixpkgs ? import <nixpkgs>, ... }:

let
  pkgs = nixpkgs {
    config = { };
    # https://github.com/NixOS/nixpkgs/blob/master/lib/systems/examples.nix
    crossSystem = (import <nixpkgs/lib>).systems.examples.armv7l-hf-multiplatform;
    #{
    #  config = "armv7l-unknown-linux-gnueabihf";
    #  #system = "arm-linux";
    #  platform = {
    #    name = "arm-board";
    #    kernelArch = "arm";
    #    gcc = {
    #      float = "hard";
    #    };
    #  };
    #};
    overlays = [ (import ./overlay.nix) ];
  };
in
  pkgs.my_package
