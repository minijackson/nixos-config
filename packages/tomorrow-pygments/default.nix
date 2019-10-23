{ python36Packages, fetchFromGitHub, ... }:

python36Packages.pygments.overrideAttrs (oldAttrs: rec {

  tomorrowTheme = fetchFromGitHub {
    owner = "MozMorris";
    repo = "tomorrow-pygments";
    rev = "c6ca1a308e7e93cb18a54f93bf964f56e4d07acf";
    sha256 = "05np4rqhb8h47z2n45ln3awnxqv5zvagxsxikdc1kbh6h7004f4v";
  };

  draculaTheme = fetchFromGitHub {
    owner = "dracula";
    repo = "pygments";
    rev = "ca501c3e7f069c29e3daa7e836a784c2aac8666f";
    sha256 = "0q3rraklpb5p5lpbdada5xx8216hywmr77bhkabclfpbnx0s9ymm";
  };

  postPatch = ''
    cp ${tomorrowTheme}/styles/* pygments/styles/
    cp ${draculaTheme}/dracula.py pygments/styles/
    sed -i \
      -e 's/String.Symbol: "#f1fa8c"/String.Symbol: "#50fa7b"/' \
      -e 's/Generic.Output: "#44475a"/Generic.Output: "#ffb86c"/' \
      -e 's/Generic.Prompt: "#f8f8f2"/Generic.Prompt: "#6272a4"/' \
      -e 's/Name.Constant: "#f8f8f2"/Name.Constant: "#ff5555"/' \
      -e 's/Name.Constant: "#f8f8f2"/Name.Constant: "#ff5555"/' \
      -e 's/Literal: "#f8f8f2"/Literal: "#bd93f9"/' \
      pygments/styles/dracula.py
  '';

  patches = [ ./mime-message-lexer.patch ];
})
