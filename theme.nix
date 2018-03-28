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
      default = "#928374";
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

  };
}
