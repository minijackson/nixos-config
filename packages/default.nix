{ pkgs ? import <nixpkgs> { } }:

{
  cquery = (import ./cquery { inherit pkgs; }).cquery;
  tomorrowPygments = (import ./tomorrow-pygments { inherit pkgs; }).tomorrowPygments;
}
