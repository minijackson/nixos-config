{ pkgs, lib, themeConfig, ... }:

let
  # Thank you:
  # https://github.com/vedard/Arc-Theme-Generator/blob/master/arc-theme-generator.py
  colorMapping = with themeConfig.colors;
  with import ../../lib/theme.nix { inherit lib; };
  let
    hex2RgbaPrefix = color:
      let rgb = hex2RGB color;
        in "rgba(${toString rgb.red}, ${toString rgb.green}, ${toString rgb.blue}";
  in {
    "#5294e2" = dominant; # Dominant color
    # Same but allows opacity
    "rgba(82, 148, 226" = hex2RgbaPrefix dominant;

    # TODO: this should be slightly lighter
    "#4DADD4" = dominant; # Lighter Dominant color
    # Same but allows opacity
    "rgba(77, 173, 212" = hex2RgbaPrefix dominant;

      #"#252a35" = "#121212";  # Gnome Panel Background
      #"#262932" = "#101010";  # Dark WM bordard
    "#2f343f" = background0;  # Dark Header BG
    # Same but allows opacity
    "rgba(47, 52, 63" = hex2RgbaPrefix background0;  # Dark Header BG
      #"#e7e8eb" = "#e8e8e8";  # Light Header BG
    "#383c4a" = background;  # Dark Background
    # Same but allows opacity
    "rgba(56, 60, 74" = hex2RgbaPrefix background;
    "#d3dae3" = foreground;  # Dark Foreground
    # Same but allows opacity
    "rgba(211, 218, 227" = hex2RgbaPrefix foreground;
    "#f5f6f7" = lightBackground;  # Light Background
    "#3b3e45" = foreground;  # Light Foreground

    "#404552" = softBackground;  # Dark Base Background (ListBox)
    # Same but allows opacity
    "rgba(64, 69, 82" = hex2RgbaPrefix softBackground;
    "#3c4150" = softBackground;  # Sidebars
    "#353945" = softBackground;  # Dark SideBar Background (Nautilus)
    "rgba(53, 57, 69, 0.95)" = background2; # Nautilus SideBar
    "#bac3cf" = foreground;  # Dark SideBar Foreground (Nautilus)

    "rgba(95, 105, 127, 0.37)" = background2; # Buttons?
    "rgba(134, 144, 165, 0.37)" = background3; # Buttons? hover
    "#484c59" = background2; # Popover menu button hover

    # Lots of text
    "rgba(207, 218, 231" = hex2RgbaPrefix foreground;
    # Some more labels (list sorting)
    "#b6bcc6" = dimForeground;
    # Links
    "#a9caf1" = brightBlue;

    # List element Hover / Selected
    "#4a85cb" = dimDominant;

      #"#323644" = "#202020";  # Dark Gnome Shell Modal background
      #"#5c616c" = "#616161";  # Light Gnome Shell Foreground
      #"#2d323d" = "#171717";  # Dark Checkbox Background
      #"#5b627b" = "#505050";  # Dark Switch Background
      #"#353a47" = "#232323";  # Dark Switch Circle
      #"#cfd6e6" = "#dbdbdb";  # Light Switch Background
    "#444a58" = background2;  # Gtk2 Dark Button Background
    "#505666" = background3;  # Gtk2 Dark Button-Hover Background
    "#3e4351" = background;  # Gtk2 Dark Button-insensitive Background
    "#2e3340" = background0;  # Gtk2 Dark Button-active Background
    # More insensitive buttons :'-(
    "rgba(68, 74, 88" = hex2RgbaPrefix background0;

    "#4b5162" = background;  # Gtk2 Dark Tooltips Background
    "#3e4350" = background0;  # Gtk2 Dark Insensitive Background
      #"#262934" = "#0E0E0E";  # Gtk2 Dark checkbox-unchecked border
      #"#2b303b" = "#151515";  # Gtk2 Dark checkbox-unchecked Background
      #"#3e434f" = "#282828";  # Gtk2 Dark scrollbar Background
      #"#2d303b" = "#151515";  # Gtk2 Dark trough Background
      #"#767b87" = "#606060";  # Gtk2 Dark slider Background
      #"#303440" = "#191919";  # Gtk2 Dark border insensitive
      #"#2b2e39" = "#131313";  # Gtk2 Dark border
    "#313541" = background0;  # Gtk2 Dark inline toolbar
  };

  #substituteArguments = with lib; concatStrings (foldAttrs (previousColor: newColor: "--replace ${previousColor} ${newColor} ") [] [colorMapping]);
  substituteArguments = with lib;
  concatStrings
    (mapAttrsToList
      (previousColor: newColor: "--replace '${previousColor}' '${newColor}' --replace '${toUpper previousColor}' '${newColor}' ")
      colorMapping);
in {
  gruvbox-arc-theme = pkgs.arc-theme.overrideAttrs (oldAttrs: {
    name = "gruvbox-arc-theme-${oldAttrs.version}";
    postPatch = ''
      # For every plaintext file
      for file in $(find . -type f -exec grep -Iq . {} \; -and -print); do
        substituteInPlace "$file" ${substituteArguments}
      done
    '';
  });
}
