{ config, pkgs, lib, ... }:

{
  options = with lib; {
    lv2Packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        Packages providing LV2 plugins to be installed.
      '';
    };
  };

  config = {
    home-manager.users.minijackson = { ... }:
    {
      xdg.configFile."pulse/client.conf".text = ''
        daemon-binary=/var/run/current-system/sw/bin/pulseaudio
      '';
    };

    lv2Packages = with (import <nixpkgs-unstable> {}); [
      calf fmsynth zynaddsubfx helm #distrho yoshimi infamousPlugins
      carla cadence
    ];

    environment.variables.LV2_PATH = map (package: "${package}/lib/lv2") config.lv2Packages;

    users.extraUsers.minijackson = {
      packages = with pkgs; [
        jack2Full qjackctl patchage a2jmidid
        fluidsynth qsynth soundfont-fluid
        qsampler
        ardour musescore hydrogen lmms
      ] ++ config.lv2Packages;
      extraGroups = [ "audio" ];
    };

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];

  };
}
