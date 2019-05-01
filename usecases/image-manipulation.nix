{ config, pkgs, ... }:

{
  nixpkgs.overlays = let
    unstable = import <nixpkgs-unstable> {};
  in [
    (self: super: {
      inherit (unstable)
        krita gimp-with-plugins gimpPlugins darktable inkscape blender;
    })
  ];

  users.extraUsers.minijackson.packages = with pkgs;
  [
    krita (gimp-with-plugins.override { plugins = [ gimpPlugins.gmic ]; })
    darktable inkscape blender
  ];
}
