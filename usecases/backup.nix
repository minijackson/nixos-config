{ pkgs, lib, config, ... }:

let
  mkPeriodicRsyncService = name: cfg: (
    lib.nameValuePair "period-rsync-${name}" {
      description = "Periodic Rsync of ${name}";
      path = with pkgs; [ rsync openssh ];
      script = "rsync -e 'ssh -i ${config.backup.sshKey}' -avu --delete '${cfg.localPath}' '${config.backup.repoBase}/${cfg.remoteDirName}'";
      serviceConfig = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ProtectSystem = "strict";
      };
    }
  );

  mkPeriodicRsyncTimer = name: cfg: (
    lib.nameValuePair "period-rsync-${name}" {
      timerConfig = {
        OnCalendar = cfg.startAt;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    }
  );

  mkBorgBackupTimer = name: cfg: (
    lib.nameValuePair "borgbackup-job-${name}" {
      timerConfig = {
        OnCalendar = cfg.startAt;
        Persistent = true;
      };
    }
  );
in {
  imports = [
    ./backup-secret.nix
  ];

  options.backup = with lib; {
    sshKey = mkOption {
      type = types.str;
      description = "Path to the private ssh key used by Borg, Rsync and such";
    };
    repoBase = mkOption {
      type = types.str;
      description = "Base repository on the server for where to store the backups";
      example = "user@machine:/path/to/base";
    };

    periodicRsync = mkOption {
      default = {};
      type = types.attrsOf (types.submodule ({ name, ... }: {
        options = {
          localPath = mkOption {
            type = types.str;
            description = "Path of the local directory to sync";
          };
          remoteDirName = mkOption {
            type = types.str;
            description = "Name of the remote directory";
          };
          startAt = mkOption {
            type = types.str;
            description = "systemd.time type date/time specification";
          };
        };
      }));
    };

  };

  config = {
    systemd.services = lib.mapAttrs' mkPeriodicRsyncService config.backup.periodicRsync;
    systemd.timers = lib.mapAttrs' mkPeriodicRsyncTimer config.backup.periodicRsync;

    backup.periodicRsync = {
      music = {
        localPath = "/home/minijackson/Music/";
        remoteDirName = "Music";
        startAt = "weekly";
      };
    };

    services.borgbackup.jobs = {
      "nixos-config" = {
        paths = "/etc/nixos";
        compression = "auto,zstd";
        encryption.mode = "none";
        environment = { BORG_RSH = "ssh -i '${config.backup.sshKey}'"; };
        repo = "${config.backup.repoBase}/borg_blah/nixos-config";
        extraCreateArgs = "--stats";
        extraPruneArgs = "--list --stats";
        prune.keep = {
          within = "2d";
          weekly = 4;
          monthly = 4;
        };
      };
      "minijackson-home" = {
        paths = "/home/minijackson/";
        exclude = [
          "/home/minijackson/.cache" "/home/minijackson/Downloads"
          "/home/minijackson/.local/share/Steam" "/home/minijackson/.steam"
          "/home/minijackson/Music"
          "/home/minijackson/.rustup" "/home/minijackson/.cargo/git" "/home/minijackson/.cargo/registry" "target/debug" "target/release" "target/rls" "*.rlib"
          "*.o" "*.pyc"
        ];
        compression = "auto,zstd";
        encryption.mode = "none";
        environment = { BORG_RSH = "ssh -i '${config.backup.sshKey}'"; };
        repo = "${config.backup.repoBase}/borg_blah/minijackson-home";
        startAt = "weekly";
        extraCreateArgs = "--stats";
        extraPruneArgs = "--list --stats";
        prune.keep = {
          weekly = 3;
          monthly = 4;
          yearly = 4;
        };
      };
    };
  };
}
