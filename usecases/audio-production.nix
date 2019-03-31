{ config, pkgs, lib, ... }:

let
  qsynth = pkgs.qsynth.overrideAttrs (oldAttrs: rec {
    name = "qsynth-0.5.4";
    version = "0.5.4";
    src = pkgs.fetchurl {
      url = "mirror://sourceforge/qsynth/${name}.tar.gz";
      sha256 = "0kpq5fxr96wnii18ax780w1ivq8ksk892ac0bprn92iz0asfysrd";
    };
    postPatch = "";
    preInstall = ''
      mv ../src/qsynth.desktop src/qsynth.desktop
    '';
  });
in {
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
    hardware.pulseaudio.package = pkgs.pulseaudioLight.override { jackaudioSupport = true; };

    home-manager.users.minijackson = { ... }:
    {
      xdg.configFile."pulse/client.conf".text = ''
        daemon-binary=/var/run/current-system/sw/bin/pulseaudio
      '';
    };

    lv2Packages = with pkgs; [
      linuxsampler
      calf fmsynth infamousPlugins yoshimi zynaddsubfx helm distrho
    ];

    environment.variables.LV2_PATH = map (package: "${package}/lib/lv2") config.lv2Packages;

    users.extraUsers.minijackson = {
      packages = with pkgs; [
        jack2Full qjackctl patchage a2jmidid
        fluidsynth qsynth soundfont-fluid
        qsampler
        ardour musescore hydrogen lmms

        (mpv.override {
          jackaudioSupport = true;
        })
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