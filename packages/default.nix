{ pkgs ? import <nixpkgs> { } }:

{
  cquery = (import ./cquery { inherit pkgs; }).cquery;
}
