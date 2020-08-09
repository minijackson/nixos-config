{ config, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {};
in {
  users.extraUsers.minijackson.packages = with unstable;
  [
    krita (gimp-with-plugins.override { plugins = [ gimpPlugins.gmic ]; })
    darktable inkscape blender
  ];
}
