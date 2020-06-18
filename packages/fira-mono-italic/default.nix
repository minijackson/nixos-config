{ stdenv, fetchzip }:

let
  rev = "7205478cac387bc63148f11e2caa2b7aac8d416b";
in fetchzip {
  name = "fira-mono-italic-2019-09-29";

  url = "https://github.com/Avi-D-coder/fira-mono-italic/archive/${rev}.zip";
  sha256 = "09kmcrxvn7vnqxgdfjaygyql793kzfkf30vxvsfri3f2jcvr89y0";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "fira-mono-italic-${rev}/distr/otf/* Italic.otf" -d $out/share/fonts/opentype
  '';
}
