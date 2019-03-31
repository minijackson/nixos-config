{ pkgs, ... }:

let
  rEnv = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      ggplot2
      tidyverse
    ];
  };
in {
  # TODO: install Nvim-R and its dependencies
  users.extraUsers.minijackson.packages = with pkgs; [
    rEnv
  ];
}
