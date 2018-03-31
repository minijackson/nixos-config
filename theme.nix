# A facility centralizing theme / colorscheme

# The default colors are based on the Gruvbox theme:
#
# - https://github.com/morhetz/gruvbox
# - https://github.com/morhetz/gruvbox-contrib

{ config, lib, ... }:

with lib;

{
  options.theme.colors = {

    dominant = mkOption {
      type = types.str;
      default = "#b8bb26";
      description = ''
        The dominant color of the theme.

        This color should be different on different hosts.
      '';
    };

    foreground = mkOption {
      type = types.str;
      default = "#ebdbb1";
      description = "The foreground (text) color";
    };

    dimForeground = mkOption {
      type = types.str;
      default = "#928374";
      description = "Like the foreground color, but one which does not burn the eyes.";
    };

    background = mkOption {
      type = types.str;
      default = "#282828";
      description = "The background color";
    };

    lightBackground = mkOption {
      type = types.str;
      default = "#504945";
      description = "Like the background color, but one which burns the eyes a little bit more.";
    };

    brightRed = mkOption {
      type = types.str;
      default = "#fb4934";
    };

    brightGreen = mkOption {
      type = types.str;
      default = "#b8bb26";
    };

    brightYellow = mkOption {
      type = types.str;
      default = "#fabd2f";
    };

    brightBlue = mkOption {
      type = types.str;
      default = "#83a598";
    };

    brightPurple = mkOption {
      type = types.str;
      default = "#d3869b";
    };

    brightAqua = mkOption {
      type = types.str;
      default = "#8ec07c";
    };

    brightOrange = mkOption {
      type = types.str;
      default = "#fe8019";
    };


    neutralRed = mkOption {
      type = types.str;
      default = "#cc241d";
    };

    neutralGreen = mkOption {
      type = types.str;
      default = "#98971a";
    };

    neutralYellow = mkOption {
      type = types.str;
      default = "#d79921";
    };

    neutralBlue = mkOption {
      type = types.str;
      default = "#458588";
    };

    neutralPurple = mkOption {
      type = types.str;
      default = "#b16286";
    };

    neutralAqua = mkOption {
      type = types.str;
      default = "#689d6a";
    };

    neutralOrange = mkOption {
      type = types.str;
      default = "#d65d0e";
    };


    fadedRed = mkOption {
      type = types.str;
      default = "#9d0006";
    };

    fadedGreen = mkOption {
      type = types.str;
      default = "#79740e";
    };

    fadedYellow = mkOption {
      type = types.str;
      default = "#b57614";
    };

    fadedBlue = mkOption {
      type = types.str;
      default = "#076678";
    };

    fadedPurple = mkOption {
      type = types.str;
      default = "#8f3f71";
    };

    fadedAqua = mkOption {
      type = types.str;
      default = "#427b58";
    };

    fadedOrange = mkOption {
      type = types.str;
      default = "#af3a03";
    };


  };
}
