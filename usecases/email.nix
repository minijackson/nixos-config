{ pkgs, ... }:

{

  imports = [
    ./email-secret.nix
  ];

  home-manager.users.minijackson = { config, ... }: {
    programs = {
      alot = {
        enable = true;
        extraConfig = ''
          theme = gruvbox
        '';
      };
      afew = {
        enable = true;
        extraConfig = ''
          [SpamFilter]
          [KillThreadsFilter]
          [ListMailsFilter]

          [FolderNameFilter]
          folder_explicit_list = Trash Corbeille
          folder_transforms = Trash:deleted Corbeille:deleted
          maildir_separator = /

          [ArchiveSentMailsFilter]
          [InboxFilter]
        '';
      };
      mbsync.enable = true;
      msmtp.enable = true;
      notmuch = {
        enable = true;
        new.tags = [ "unread" "inbox" "new" ];
        hooks = with pkgs; {
          preNew = "${isync}/bin/mbsync --verbose --all";
          postNew = "${afew}/bin/afew --verbose --tag --new";
        };
      };
    };

    xdg.configFile."alot/themes/gruvbox".source = ../res/alot-theme.ini;

    /*
    systemd.user = {
      services.mail-sync = {
        Unit = {
          Description = "Mail sync";
          After = [ "network.target" ];
        };
        Service = {
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          Environment= [
            "NOTMUCH_CONFIG=${config.xdg.configHome}/notmuch/notmuchrc"
            "NMBGIT=${config.xdg.dataHome}/notmuch/nmbug"
          ];
          # Should have mbsync as preNew hook
          # And have afew as postNew hook
          ExecStart = "${pkgs.notmuch}/bin/notmuch new";
        };
      };
      timers.mail-sync = {
        Unit = {
          Description = "Mail sync";
        };
        Timer = {
          OnCalendar = "hourly";
          Unit = "mail-sync.service";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
    */
  };
}
