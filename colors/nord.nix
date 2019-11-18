{ lib, config, ... }:

with lib; with config.theme.colors; {
  theme.colors = {
    foreground = mkDefault "#eceff4";
    dimForeground = mkDefault "#e5e9f0";

    background = mkDefault background1;
    softBackground = mkDefault background2;
    lightBackground = mkDefault background3;

    background0 = mkDefault "#2e3440";
    background1 = mkDefault "#3b4252";
    background2 = mkDefault "#434c5e";
    background3 = mkDefault "#4c566a";
    background4 = mkDefault "#d8dee9";
    background5 = mkDefault "#e5e9f0";
    background6 = mkDefault "#eceff4";

    brightRed = mkDefault "#bf617a";
    neutralRed = mkDefault brightRed;
    fadedRed = mkDefault brightRed;

    brightGreen = mkDefault "#a3be8c";
    neutralGreen = mkDefault brightGreen;
    fadedGreen = mkDefault brightGreen;

    brightYellow = mkDefault "#ebcb8b";
    neutralYellow = mkDefault brightYellow;
    fadedYellow = mkDefault brightYellow;

    brightPurple = mkDefault "#b48ead";
    neutralPurple = mkDefault brightPurple;
    fadedPurple = mkDefault brightPurple;

    brightOrange = mkDefault "#b48ead";
    neutralOrange = mkDefault brightOrange;
    fadedOrange = mkDefault brightOrange;

    brightBlue = mkDefault "#81a1c1";
    neutralBlue = mkDefault "#5e81ac";
    fadedBlue = mkDefault neutralBlue;

    brightAqua = mkDefault "#88c0d0";
    neutralAqua = mkDefault "#8fbcbb";
    fadedAqua = mkDefault neutralAqua;
  };
}
