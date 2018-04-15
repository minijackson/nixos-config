{ config, pkgs, ... }:

let
  common-home-configuration = {
    manual.manpages.enable = true;
    programs.git = {
      enable = true;
      userEmail = "minijackson@riseup.net";
      userName = "Minijackson";
    };
  };

  globalConfig = config;
in
{
  imports = [
    ./home-manager/nixos
    ./theme.nix
  ];

  users.extraUsers.minijackson.packages = with pkgs; [
    pass
    tmuxp
    tokei
    neofetch
    ffmpeg beets mpv youtube-dl pavucontrol
    pandoc poppler_utils
    rr rtags gcc clang clang-tools
    aspell aspellDicts.en aspellDicts.en-computers aspellDicts.en-science aspellDicts.fr
  ];

  home-manager.users.root = { ... }:
  common-home-configuration // {
  };

  home-manager.users.minijackson = { config, ... }:
  common-home-configuration // {

    services = {

      udiskie.enable = true;

      redshift = {
        enable = true;
        latitude = "48.864716";
        longitude = "2.349014";
      };

      dunst = {
        enable = true;
        settings = with globalConfig.theme.colors;
        {
          global = {
            geometry = "300x5-30+50";

            format = "<b>%a</b>: %s\\n%b";
            alignment = "center";
            word_wrap = "yes";
            stack_duplicates = "yes";

            frame_width = 1;
            frame_color = dimForeground;
            foreground = foreground;
            padding = 30;
            horizontal_padding = 20;
          };
          urgency_low = {
            background = background;
          };
          urgency_normal = {
            background = background;
          };
          urgency_critical = {
            background = background;
          };
          shortcuts = {
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
          };
        };
      };

      polybar = {
        enable = true;
        package = pkgs.polybar.override {
          i3GapsSupport = true;
          mpdSupport = true;
        };
        # Fix for polybar to be able to find i3's socket
        # https://github.com/rycee/home-manager/issues/206
        script = "PATH=$PATH:${pkgs.i3}/bin polybar main &";
        config = with globalConfig.theme.colors;
        {

          "bar/main" = {
            bottom = "true";
            width = "100%";
            height = "27";
            background = "${background}";
            foreground = "${foreground}";

            line-size   = 2;
            line-color  = "${background}";

            module-margin = 2;
            padding-left  = 0;
            padding-right = 2;

            font-0 = "monospace:pixelsize=8;0";
            font-1 = "unifont:size=8:heavy:fontformat=truetype;-2";
            font-2 = "siji:pixelsize=10;0";

            modules-left = "i3";
            modules-center = "mpd";
            modules-right = "backlight volume memory cpu wlan eth battery temperature date redshift powermenu";

            fixed-center = false;

            tray-position = "right";
            tray-padding  = 2;

            scroll-up   = "i3wm-wsnext";
            scroll-down = "i3wm-wsprev";
          };

          "module/i3" = {
            type = "internal/i3";

            format = "<label-state> <label-mode>";
            index-sort = true;
            wrapping-scroll = false;

            label-mode-padding = 2;

            label-focused-background = lightBackground;
            label-focused-underline  = dominant;

            label-urgent-background = neutralRed;

            label-focused   = "%index%";
            label-unfocused = "%index%";
            label-urgent    = "%index%!";
            label-visible   = "%index%";

            label-focused-padding   = 2;
            label-unfocused-padding = 2;
            label-urgent-padding    = 2;
            label-visible-padding   = 2;
          };

          "module/mpd" = {
            type = "internal/mpd";

            format-online = "%{F${dominant}}%{F-} <label-song>  <icon-prev> <icon-stop> %{F${dominant}}<toggle>%{F-} <icon-next>";
            format-stopped = "%{F${dominant}}<toggle>%{F-}";

            label-song-maxlen = 100;
            label-song-ellipsis = true;

            icon-prev  = "";
            icon-seekb = "";
            icon-stop  = "";
            icon-play  = "";
            icon-pause = "";
            icon-next  = "";
            icon-seekf = "";

            icon-random = "";
            icon-repeat = "";

            toggle-on-foreground = dominant;
            toggle-off-foreground = dimForeground;
          };

          "module/backlight" = {
            type = "internal/backlight";
            card = "intel_backlight";

            format = "<label> <bar>";
            label = "%{F${brightBlue}}";

            bar-width = 10;
            bar-indicator = "●";
            bar-indicator-foreground = foreground;
            bar-indicator-font = 1;
            bar-fill = "─";
            bar-fill-font = 1;
            bar-fill-foreground = brightBlue;
            bar-empty = "─";
            bar-empty-font = 1;
            bar-empty-foreground = dimForeground;
          };

          "module/volume" = {
            type = "internal/volume";

            format-volume = "<label-volume> <bar-volume>";
            label-volume = "";
            label-volume-foreground = brightGreen;

            format-muted-prefix = " ";
            format-muted-foreground = dimForeground;
            label-muted = "sound muted";

            bar-volume-width = 10;
            bar-volume-foreground-0 = brightGreen;
            bar-volume-foreground-1 = brightGreen;
            bar-volume-foreground-2 = brightGreen;
            bar-volume-foreground-3 = brightGreen;
            bar-volume-foreground-4 = brightGreen;
            bar-volume-foreground-5 = brightYellow;
            bar-volume-foreground-6 = brightRed;
            bar-volume-gradient = false;
            bar-volume-indicator = "●";
            bar-volume-indicator-font = 1;
            bar-volume-indicator-foreground = foreground;
            bar-volume-fill = "─";
            bar-volume-fill-font = 1;
            bar-volume-empty = "─";
            bar-volume-empty-font = 1;
            bar-volume-empty-foreground = dimForeground;
          };

          "module/memory" = {
            type = "internal/memory";
            format-prefix = " ";
            format-prefix-foreground = neutralBlue;
            format-underline = neutralBlue;
          };

          "module/cpu" = {
            type = "internal/cpu";
            format-prefix = " ";
            format-prefix-foreground = neutralOrange;
            format-underline = neutralOrange;
          };

          "module/wlan" = {
            type = "internal/network";
            interface = "wlp2s0";

            format-connected = "<ramp-signal> <label-connected>";
            format-connected-underline = brightGreen;

            label-connected = "%essid%";
            label-disconnected = null;

            ramp-signal-0 = "";
            ramp-signal-1 = "";
            ramp-signal-2 = "";
            ramp-signal-3 = "";
            ramp-signal-4 = "";
            ramp-signal-foreground = brightGreen;
          };

          "module/eth" = {
            type = "internal/network";
            interface = "enp3s0";

            format-connected-prefix = " ";
            format-connected-underline = brightGreen;
            format-connected-foreground = brightGreen;

            label-connected = "%local_ip%";
            label-disconnected = null;
          };

          "module/battery" = {
            type = "internal/battery";
            battery = "BAT1";
            adapter = "ADP1";
            full-at = 90;

            format-charging = "<animation-charging> <label-charging>";
            format-charging-underline = brightYellow;

            format-discharging = "<ramp-capacity> <label-discharging>";
            format-discharging-underline = brightYellow;

            format-full-prefix = " ";
            format-full-prefix-foreground = neutralYellow;
            format-full-underline = neutralYellow;

            ramp-capacity-0 = "";
            ramp-capacity-1 = "";
            ramp-capacity-2 = "";
            ramp-capacity-foreground = brightYellow;

            animation-charging-0 = "";
            animation-charging-1 = "";
            animation-charging-2 = "";
            animation-charging-foreground = brightYellow;
            animation-charging-framerate = 750;
          };

          "module/temperature" = {
            type = "internal/temperature";

            format = "<ramp> <label>";
            format-underline = brightAqua;

            label = "%temperature%";
            label-warn = "%temperature%";
            label-warn-foreground = brightYellow;

            ramp-0 = "";
            ramp-1 = "";
            ramp-2 = "";
            ramp-foreground = brightAqua;
          };

          "module/date" = {
            type = "internal/date";

            date = null;
            date-alt = " %Y-%m-%d";

            time = "%H:%M";
            time-alt = "%H:%M:%S";

            format-prefix = "";
            format-prefix-foreground = neutralPurple;
            format-underline = neutralPurple;

            label = "%date% %time%";
          };

          "module/redshift" = let systemctl = "${pkgs.systemd}/bin/systemctl";
          in {
            type = "custom/script";

            exec = "${systemctl} --user is-active --quiet redshift.service && echo '%{F${neutralOrange}}' || echo '%{F${brightBlue}}'";
            interval = 10;

            label = "%output%%{F-}";

            click-left = "${systemctl} --user is-active --quiet redshift.service && ${systemctl} --user stop redshift.service || ${systemctl} --user start redshift.service";
          };

          "module/powermenu" = let systemctl = "${pkgs.systemd}/bin/systemctl";
          in {
            type = "custom/menu";

            label-open = " power";
            label-open-foreground = dominant;
            label-close = " cancel";
            label-close-foreground = dominant;
            label-separator = "|";
            label-separator-foreground = dimForeground;

            menu-0-0 = "reboot";
            menu-0-0-exec = "menu-open-1";
            menu-0-1 = "power off";
            menu-0-1-exec = "menu-open-2";

            menu-1-0 = "cancel";
            menu-1-0-exec = "menu-open-0";
            menu-1-1 = "reboot";
            menu-1-1-exec = "${systemctl} reboot";

            menu-2-0 = "power off";
            menu-2-0-exec = "${systemctl} poweroff";
            menu-2-1 = "cancel";
            menu-2-1-exec = "menu-open-0";
          };

        };
      };

      screen-locker = {
        enable = true;
        lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
      };

      random-background = {
        enable = true;
        imageDirectory = toString ./res/wallpapers;
        interval = "20 minutes";
      };

      gnome-keyring.enable = true;

    };

    programs = {
      browserpass.enable = true;
      firefox.enable = true;
      pidgin.enable = true;

      rofi = {
        enable = true;

        theme = with globalConfig.theme.colors;
        builtins.toFile "theme.rasi" ''
          * {
            dominant: ${dominant};

            foreground: ${foreground};
            dim-foreground: ${dimForeground};

            text-color: @foreground;
            border-color: @dim-foreground;

            background-color: ${background};
            light-background: ${lightBackground};
          }

          #window {
            padding: 8px;

            border:  1px solid;
            background-color: @background;
          }

          #mainbox {
            border:  0;
            padding: 0;
          }

          #inputbar {
            spacing: 0;
            padding: 5px;
            border: 0 0 1px 0;
            margin: 0 0 8px 0;
            children: [ prompt, textbox-prompt-sep, entry ];
          }

          #prompt {
            background-color: @background;
            text-color: @dim-foreground;
          }

          textbox-prompt-sep {
            expand: false;
            str: ":";
            text-color: @dim-foreground;
            margin: 0 8px 0 0;
          }

          #message {
            spacing: 0;
            padding: 5px;
            border: 0 0 1px 0;
            margin: 0 0 8px 0;
          }

          #listview {
            spacing: 0;
          }

          #element {
            border:  0;
            padding: 5px;

            background-color: @background;
          }

          #element.selected.normal {
            background-color: @dominant;
          }

          #element.urgent {
            background-color: ${fadedRed};
          }

          #element.selected.urgent {
            background-color: ${neutralRed};
          }

          #element.active {
            background-color: ${dimForeground};
            text-color: ${background};
          }

          #element.selected.active {
            background-color: ${foreground};
            text-color: ${background};
          }

          #scrollbar {
            width: 4px;
            handle-width: 8px;
          }
        '';

      };
    };

    xdg.configFile."alacritty/alacritty.yml".source = ./dotfiles/alacritty.yml;

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.arc-icon-theme;
        name = "Arc";
      };
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Darker";
      };
    };

    home.keyboard = with globalConfig.services.xserver;
    {
      layout  = layout;
      variant = xkbVariant;
      options = [ xkbOptions "compose:caps" ];
    };

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config = {
          bars = [];
          floating.modifier = "Mod4";
          floating.border = 0;

          keybindings = {
            "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            "Mod4+d"      = "exec \"${pkgs.rofi}/bin/rofi -modi drun,window,run -show drun\"";

            "Mod4+Shift+q" = "kill";

            "Mod4+Left"  = "focus left";
            "Mod4+Down"  = "focus down";
            "Mod4+Up"    = "focus up";
            "Mod4+Right" = "focus right";

            "Mod4+Shift+Left"  = "move left";
            "Mod4+Shift+Down"  = "move down";
            "Mod4+Shift+Up"    = "move up";
            "Mod4+Shift+Right" = "move right";

            "Mod4+h" = "split h";
            "Mod4+v" = "split v";
            "Mod4+f" = "fullscreen toggle";

            "Mod4+s" = "layout stacking";
            "Mod4+z" = "layout tabbed";
            "Mod4+e" = "layout toggle split";

            "Mod4+space"       = "focus mode_toggle";
            "Mod4+Shift+space" = "floating toggle";

            "Mod4+a" = "focus parent";

            "Mod4+1" = "workspace 1";
            "Mod4+2" = "workspace 2";
            "Mod4+3" = "workspace 3";
            "Mod4+4" = "workspace 4";
            "Mod4+5" = "workspace 5";
            "Mod4+6" = "workspace 6";
            "Mod4+7" = "workspace 7";
            "Mod4+8" = "workspace 8";
            "Mod4+9" = "workspace 9";
            "Mod4+0" = "workspace 10";

            "Mod4+Shift+1" = "move container to workspace 1";
            "Mod4+Shift+2" = "move container to workspace 2";
            "Mod4+Shift+3" = "move container to workspace 3";
            "Mod4+Shift+4" = "move container to workspace 4";
            "Mod4+Shift+5" = "move container to workspace 5";
            "Mod4+Shift+6" = "move container to workspace 6";
            "Mod4+Shift+7" = "move container to workspace 7";
            "Mod4+Shift+8" = "move container to workspace 8";
            "Mod4+Shift+9" = "move container to workspace 9";
            "Mod4+Shift+0" = "move container to workspace 10";

            "Mod4+Shift+c" = "reload";
            "Mod4+Shift+r" = "restart";
            "Mod4+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

            "Mod4+r" = "mode resize";

            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute"        = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

            "XF86MonBrightnessUp"   = "exec --no-startup-id light -A 5";
            "XF86MonBrightnessDown" = "exec --no-startup-id light -U 5";

            "Mod4+m" = "exec --no-startup-id ${config.services.screen-locker.lockCmd}";
          };

          startup = [
            { command = "systemctl --user restart polybar"; always = true; notification = false; }
          ];

          window = {
            border = 0;
            titlebar = false;
          };

        };
      };

      pointerCursor = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        size = 24;
      };

    };
  };

}
