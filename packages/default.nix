{ pkgs ? import <nixpkgs> { } }:

{
  cquery = (import ./cquery { inherit pkgs; }).cquery;
  tomorrowPygments = (import ./tomorrow-pygments { inherit pkgs; }).tomorrowPygments;
  zsh-history-substring-search = (import ./zsh-history-substring-search { inherit pkgs; }).zsh-history-substring-search;
}
