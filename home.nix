{ config, pkgs, lib, ... }:

let
  common-home-configuration = {
    home.stateVersion = "19.03";

    manual.manpages.enable = true;
    programs = {
      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userEmail = "minijackson@riseup.net";
        userName = "Minijackson";

        extraConfig = {
          core = { whitespace = "trailing-space,space-before-tab"; };
          merge = { tool = "nvimdiff"; };
          "mergetool \"nvimdiff\"" = { cmd = "nvim -d \"$LOCAL\" \"$MERGED\" \"$REMOTE\""; };
        };
      };

      bat = {
        enable = true;
        config = {
          theme = "TwoDark";
        };
      };

      htop = {
        enable = true;

        fields = [
          "PID" "USER"
          "PRIORITY" "NICE"
          "STATE"
          "IO_PRIORITY" "IO_READ_RATE" "IO_WRITE_RATE"
          "PERCENT_CPU" "PERCENT_MEM"
          "TIME"
          "COMM"
        ];

        hideThreads = true;
        hideUserlandThreads = true;
        showThreadNames = true;

        highlightBaseName = true;

        # On NixOS? NO.
        showProgramPath = false;

        treeView = true;

        meters = {
          left = [ "LeftCPUs" "Memory"  "Swap" "Blank" { kind = "Battery"; mode = 1; } ];
          right = [ "RightCPUs" "Blank" "Tasks" "LoadAverage" "Uptime" ];
        };

      };
    };
  };

  globalConfig = config;

  wRedshift = pkgs.redshift.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "giucam";
      repo = "redshift";
      rev = "1b9c8ac11125e2df0b8f9779376dd35cd56d5951";
      sha256 = "0llylabqp38y7mq3wzvnwm82f079n24gzf2hy53v1zpwklvcwjg9";
    };
  });

in
{
  imports = [
    <home-manager/nixos>
    ./taskwarrior-secret.nix
    ./theme.nix
  ];

  users.extraUsers.minijackson.packages = with pkgs; [
    pass
    tmuxp
    taskwarrior
    tokei
    neofetch
    ffmpeg beets youtube-dl pavucontrol
    pandoc poppler_utils
    rr rtags gcc clang clang-tools
    aspell aspellDicts.en aspellDicts.en-computers aspellDicts.en-science aspellDicts.fr

    wRedshift
  ];

  home-manager.users.root = { ... }:
  lib.recursiveUpdate common-home-configuration {
  };

  home-manager.users.minijackson = { config, ... }:
  lib.recursiveUpdate common-home-configuration {

    services = {

      udiskie.enable = true;

      redshift = {
        enable = true;

        latitude = "48.864716";
        longitude = "2.349014";

        # Reduce blue light anyways
        temperature = {
          day = 4000;
          night = 2500;
        };
      };

      dunst = {
        enable = false;
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
            modules-right = "backlight volume memory cpu wlan eth battery temperature date redshift autolock powermenu";

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
            label-disconnected = "";

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
            label-disconnected = "";
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

            date = "";
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

          "module/autolock" = let
            systemctl = "${pkgs.systemd}/bin/systemctl";
            xset = "${pkgs.xorg.xset}/bin/xset";
          in {
            type = "custom/script";

            exec = "${systemctl} --user is-active --quiet xautolock-session.service && echo '%{F${neutralGreen}}' || echo '%{F${neutralRed}}'";

            label = "%output%%{F-}";

            click-left = "${systemctl} --user is-active --quiet xautolock-session.service && (${systemctl} --user stop xautolock-session.service; ${xset} s 0 0; ${xset} -dpms) || (${systemctl} --user start xautolock-session.service; ${xset} s; ${xset} +dpms)";
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
        xautolockExtraOptions = [
          "-corners" "00-0"
          "-cornerdelay" "3"
        ];
      };

      random-background = {
        enable = true;
        imageDirectory = toString ./res/wallpapers;
        interval = "20 minutes";
      };

      gnome-keyring.enable = true;

    };

    programs = {

      git.signing = {
        signByDefault = true;
        key = "minijackson@riseup.net";
      };

      firefox.enable = true;
      pidgin.enable = true;

      htop.shadowOtherUsers = true;

      taskwarrior = {
        enable = true;
        colorTheme = "dark-16";

        # config set in taskwarrior-secret.nix
      };

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

    home.file = {
      "Templates" = {
        source = ./res/templates;
        recursive = true;
      };
    };

    xdg.configFile = {
      "alacritty/alacritty.yml".source = ./dotfiles/alacritty.yml;

      "mpv/mpv.conf".text = ''
        hwdec=auto
      '';

      "zathura/zathurarc".source = ./dotfiles/zathurarc;

      "user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/Desktop"
        XDG_DOCUMENTS_DIR="$HOME/Documents"
        XDG_DOWNLOAD_DIR="$HOME/Downloads"
        XDG_MUSIC_DIR="$HOME/Music"
        XDG_PICTURES_DIR="$HOME/Pictures"
        XDG_PUBLICSHARE_DIR="$HOME/Public"
        XDG_TEMPLATES_DIR="$HOME/Templates"
        XDG_VIDEOS_DIR="$HOME/Videos"
      '';

      "sway/config".source = pkgs.substituteAll {

        src = ./dotfiles/sway;

        inherit (globalConfig.theme.colors) dominant;
        inherit (pkgs) mpc_cli pulseaudio;

        choose_password = pkgs.substituteAll {
          src = ./scripts/choose_password.sh;
          isExecutable = true;

          inherit (pkgs) rofi pass;
        };

        choose_album = pkgs.substituteAll {
          src = ./scripts/choose_album.sh;
          isExecutable = true;

          inherit (pkgs) sqlite mpc_cli rofi;
        };

        choose_artist = pkgs.substituteAll {
          src = ./scripts/choose_artist.sh;
          isExecutable = true;

          inherit (pkgs) mpc_cli rofi;
        };

        random_albums = pkgs.substituteAll {
          src = ./scripts/random_albums.sh;
          isExecutable = true;

          inherit (pkgs) mpc_cli beets;
        };

        import_gsettings = pkgs.substituteAll {
          src = ./scripts/import_gsettings.sh;
          isExecutable = true;

          gsettings = pkgs.glib.dev;
          gsettings_desktop_schemas = pkgs.gsettings-desktop-schemas;
          gsettings_desktop_schemas_name = pkgs.gsettings-desktop-schemas.name;
          dconf_lib = pkgs.gnome3.dconf.lib;
        };
      };

      "swaylock/config".text = with globalConfig.theme.colors; ''
        ignore-empty-password
        image=/etc/nixos/res/wallpapers/wallpaper-1920x1080-install-gentoo.png

        font=monospace

        inside-color=${lib.removePrefix "#" dominant}dd
        inside-clear-color=${lib.removePrefix "#" neutralOrange}dd
        inside-ver-color=${lib.removePrefix "#" neutralOrange}dd
        inside-wrong-color=${lib.removePrefix "#" neutralRed}dd

        key-hl-color=${lib.removePrefix "#" brightGreen}ee
        bs-hl-color=${lib.removePrefix "#" neutralRed}ee

        line-color=${lib.removePrefix "#" background}ee
        line-clear-color=${lib.removePrefix "#" background}ee
        line-ver-color=${lib.removePrefix "#" background}ee
        line-wrong-color=${lib.removePrefix "#" background}ee

        ring-color=${lib.removePrefix "#" dominant}ee
        ring-clear-color=${lib.removePrefix "#" brightOrange}ee
        ring-ver-color=${lib.removePrefix "#" brightOrange}ee
        ring-wrong-color=${lib.removePrefix "#" brightRed}ee

        separator-color=${lib.removePrefix "#" background}ee

        text-color=${lib.removePrefix "#" background}ff
        text-clear-color=${lib.removePrefix "#" background}ff
        text-ver-color=${lib.removePrefix "#" background}ff
        text-wrong-color=${lib.removePrefix "#" background}ff

        indicator-radius=75
        indicator-thickness=10
      '';

      "waybar/style.css".source = pkgs.substituteAll {
        src = ./dotfiles/waybar-style.css;

        # TODO: maybe add transparency?
        inherit (globalConfig.theme.colors)
          dominant dimDominant
          background lightBackground background6
          foreground
          neutralPurple neutralYellow fadedRed neutralOrange brightBlue neutralGreen neutralAqua brightAqua;
      };

      "waybar/config".text = builtins.toJSON {
        layer = "top";
        position = "bottom";
        height = 25;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "mpd" ];
        modules-right = [ "idle_inhibitor" "pulseaudio" "network#eth" "network#wlan" "cpu" "memory" "temperature" "backlight" "battery" "clock" "tray" ];

        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) <span font_desc='Font Awesome 5 Free'></span>";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped <span font_desc='Font Awesome 5 Free'></span>";
          format-disconnected = "Disconnected <span font_desc='Font Awesome 5 Free'></span>";

          on-click-middle = "alacritty --dimensions 200 50 --command ncmpcpp";

          consume-icons = {
            on = " ";
          };

          random-icons = {
            on = " ";
          };

          repeat-icons = {
            on = " ";
          };

          single-icons = {
            on = "1 ";
          };

          state-icons = {
            playing = "";
            paused = "";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        clock = {
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = { format = "{usage}% "; };

        memory = { format = "{}% "; };

        battery = {
          states = { good = 90; };
          format = "{capacity}% {icon}";
          format-icons = [
            "<span font_desc='Font Awesome 5 Free'></span>"
            "<span font_desc='Font Awesome 5 Free'></span>"
            "<span font_desc='Font Awesome 5 Free'></span>"
            "<span font_desc='Font Awesome 5 Free'></span>"
            "<span font_desc='Font Awesome 5 Free'></span>"
          ];
        };

        "network#eth" = {
          interface = "enp3s0";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ";
        };

        "network#wlan" = {
          interface = "wlp2s0";
          format-wifi = "{essid} ({signalStrength}%) <span font_desc='Font Awesome 5 Free'></span>";
          format-disconnected = "Disconnected <span font_desc='Font Awesome 5 Free'></span>";
          tooltip = true;
          tooltip-format-wifi = "{ipaddr}/{cidr}";
        };

        temperature = { format = "{temperatureC} °C "; };

        backlight = {
          format = "{percent}% <span font_desc='Font Awesome 5 Free'>{icon}</span>";
          format-icons = [ "" "" ];
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          on-click = "pavucontrol";
        };

        # TODO: move that into usecases/music.nix
        "custom/mpd" = {
          exec = "${pkgs.mpc_cli}/bin/mpc current --format '%artist% - %album% - %title%'";
          interval = 10;
          format = "{} <span font_desc='Font Awesome 5 Free'></span>";
          tooltip = false;
          on-click = "${pkgs.mpc_cli}/bin/mpc toggle";
          # TODO: hardcoded package(s) :-/
          on-click-right = "alacritty --dimensions 200 50 --command ncmpcpp";
          escape = true;
        };

      };

      "mako/config".text = with globalConfig.theme.colors; ''
        font=monospace 11

        background-color=${background}EE
        text-color=${foreground}FF
        border-size=1
        border-color=${dimForeground}EE

        width=350
        # Maximum height
        height=500

        margin=30,50
        padding=20,30

        default-timeout=7000

        [urgency=high]
        text-color=${neutralRed}

        [urgency=low]
        text-color=${neutralBlue}

        [actionable]
        border-color=${dominant}FF
        border-size=2
      '';
    };

    gtk = let
      override-arc-theme = import ./lib/override-arc-theme.nix { inherit lib; themeConfig = globalConfig.theme; };
    in {
      enable = true;
      iconTheme = {
        package = (override-arc-theme pkgs.arc-icon-theme).overrideAttrs (oldAttrs: {
          nativeBuildInputs = with pkgs; oldAttrs.nativeBuildInputs ++ [ inkscape optipng ];
          postPatch = ''
            rm -rf Arc
            substituteInPlace src/render_icons.sh --replace '/usr/bin/inkscape' 'inkscape' --replace '/usr/bin/optipng' 'optipng'

          '' + oldAttrs.postPatch;
          # Re-generate PNG icons from SVG files
          postAutoreconf = ''
            cd src

            # Shut up inkscape's warnings about creating profile directory
            export HOME="$NIX_BUILD_ROOT"
            bash render_icons.sh

            cd ..
          '';
        });
        name = "Arc";
      };
      theme = {
        package = override-arc-theme pkgs.arc-theme;
        name = "Arc-Dark";
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
          floating = {
            modifier = "Mod4";
            criteria = [
              { title = "Steam - News"; }
              { class = "Pavucontrol"; }
            ];
            border = 1;
          };

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

            "Mod4+p" = "exec --no-startup-id ${pkgs.substituteAll {
              src = ./scripts/choose_password.sh;
              isExecutable = true;

              inherit (pkgs) rofi pass;
            }}";
          };

          startup = [
            { command = "systemctl --user restart polybar"; always = true; notification = false; }
          ];

          window = {
            border = 1;
            hideEdgeBorders = "smart";
            titlebar = false;
          };

          colors = with globalConfig.theme.colors; rec {

            focused = {
              background = lightBackground;
              text = foreground;
              border = lightBackground;

              childBorder = dominant;
              indicator = brightOrange;
            };

            focusedInactive = unfocused;
            unfocused = {
              inherit background;
              text = dimForeground;
              border = background;

              childBorder = background;
              indicator = brightOrange;
            };

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
