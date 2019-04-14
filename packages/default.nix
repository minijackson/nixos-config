{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib, config }:

{
  tomorrowPygments = (import ./tomorrow-pygments { inherit pkgs; }).tomorrowPygments;
  autoEq = (import ./AutoEq { inherit pkgs; }).autoEq;
  zsh-history-substring-search = (import ./zsh-history-substring-search { inherit pkgs; }).zsh-history-substring-search;
}
