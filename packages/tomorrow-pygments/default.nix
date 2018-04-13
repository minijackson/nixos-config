{ pkgs, ... }:

{
  tomorrowPygments = pkgs.python36Packages.pygments.overrideAttrs ( oldAttrs: {
    patches = [ ./add-tomorrow-themes.patch ];
  });
}
