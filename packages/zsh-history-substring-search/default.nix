{ pkgs ? import <nixpkgs> { } }:

let
  releaseInfo = builtins.fromJSON (builtins.readFile ./release-info.json);
in with pkgs;
{
  zsh-history-substring-search = stdenv.mkDerivation {
    name = "zsh-history-substring-search.zsh";

    src = fetchgit {
      inherit (releaseInfo) url rev sha256;
    };

    buildPhase = ":";

    installPhase = ''
      cp zsh-history-substring-search.zsh $out
      chmod +x $out
    '';
  };
}
