{ pkgs ? import <nixpkgs> { } }:

let
  releaseInfo = builtins.fromJSON (builtins.readFile ./release-info.json);
in with pkgs;
{
  cquery = stdenv.mkDerivation {
    name = "cquery";

    nativeBuildInputs = [ cmake gcc ninja ];
    buildInputs = [ llvmPackages_6.clang-unwrapped ];

    src = fetchgit {
      inherit (releaseInfo) url rev sha256;
    };


    cmakeFlags = [
      "-DSYSTEM_CLANG=ON"
    ];

  };
}
