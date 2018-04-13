{ pkgs, ... }:

let
  myPackages = import ../packages { inherit pkgs; };
# TODO: https://github.com/MozMorris/tomorrow-pygments
  texliveEnv = with pkgs; texlive.combine {
    inherit (texlive)
      scheme-small

      latexmk
      texdoc
      # Needed for texdoc but somehow not automatically added
      luatex

      collection-langenglish
      collection-langfrench
      csquotes

      microtype
      fontspec
      cm-super

      biber
      biblatex
      biblatex-ieee

      algorithms
      minted

      todonotes

      # Dependencies somehow missing
      logreq xstring fvextra ifplatform framed
      ;
  };
in {

  users.extraUsers.minijackson.packages = with pkgs; [
    texliveEnv
    biber
    myPackages.tomorrowPygments
    zathura xdotool
  ];

  # Fira Code is nice for code reading
  fonts.fonts = with pkgs; [ fira-code cm_unicode ];
}
