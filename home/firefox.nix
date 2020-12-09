{ pkgs, config, ... }:

let
  firefox = (import <nixpkgs-unstable> {}).firefox-wayland;
in {

  home-manager.users.minijackson = { ... }:
  {
    programs.firefox = {
      enable = true;
      package = firefox;

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # Security
        https-everywhere

        # Privacy
        canvasblocker
        clearurls
        decentraleyes
        google-search-link-fix
        privacy-badger
        ublock-origin
        umatrix

        # Additional features
        betterttv
        sidebery
        stylus
        tridactyl

        # Annoyances
        buster-captcha-solver
        terms-of-service-didnt-read

        # Missing

        # Dark Website Forcer
        # uBO-Scope
        # Conex?
        # Flagfox
        # Native MathML
        # Privacy Settings
        # Rust Search Extension
        # SponsorBlock
        # French dictionary
      ];

      profiles.home-manager-default = {
        id = 0;
        isDefault = true;

        settings = let
          homepage = pkgs.substituteAll {
            src = ../res/homepage.html;

            inherit (config.theme.colors)
              dominant
              background background2
              foreground
              neutralRed;
          };
        in {
          # == Performance ==

          "gfx.webrender.all" = true;
          "gfx.webrender.compositor" = true;
          "gfx.webrender.enabled" = true;
          "layers.acceleration.force-enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;

          # Newtab page
          "browser.aboutHomeSnippets.updateUrl" = "";
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.discoverystream.config" = "{}";
          "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
          "browser.newtabpage.activity-stream.discoverystream.endpoints" = "";
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories.options" = "{}";
          "browser.newtabpage.activity-stream.feeds.sections" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.system.systemtick" = false;
          "browser.newtabpage.activity-stream.feeds.system.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.system.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.snippets" = false;

          # == Behavior ==

          "browser.bookmarks.showMobileBookmarks" = true;
          # Don't try to guess TLDs, I'm using custom ones
          "browser.fixup.alternate.enabled" = false;
          "browser.fixup.domainwhitelist.huh.lan" = true;
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "browser.startup.page" = 3; # Restore previous session
          "browser.startup.homepage" = "file://${homepage}";
          "browser.tabs.warnOnClose" = false;

          "reader.color_scheme" = "dark";

          # Syncing
          "services.sync.engine.addons" = false;
          "services.sync.engine.addresses" = false;
          "services.sync.engine.creditcards" = false;
          "services.sync.engine.prefs" = false;

          # Enable loading of userChrome
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # == Security ==

          "security.pki.sha1_enforcement_level" = 1; # Completely forbid it
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "network.security.esni.enabled" = true;

          # == General web privacy ==

          "beacon.enabled" = false;

          "browser.send_pings" = false;

          "browser.search.countryCode" = "US";
          "browser.search.region" = "US";
          "browser.search.geoip.url" = "";
          "browser.search.geoSpecificDefaults" = false;

          "camera.control.face_detection.enabled" = false;

          "device.sensors.enabled" = false;

          "dom.archivereader.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.event.clipboardevents.enabled" = false;
          "dom.event.contextmenu.enabled" = false;
          "dom.gamepad.enabled" = false;
          "dom.maxHardwareConcurrency" = 2;
          "dom.netinfo.enabled" = false;
          "dom.network.enabled" = false;
          "dom.telephony.enabled" = false;
          "dom.vr.enabled" = false;
          "dom.vibrator.enabled" = false;

          # User-Agent already spoofed by 'resistFingerprinting'
          # Apparently doesn't work
          /*
          "general.appversion.override" = "5.0 (Windows)";
          "general.platform.override" = "Win32";
          "general.oscpu.override" = "Windows NT 6.1";
          */

          "geo.enabled" = false;
          "geo.wifi.uri" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
          "geo.wifi.logging.enabled" = false;

          "intl.accept_languages" = "en-US, en";
          "intl.locale.matchOS" = false;

          "javascript.use_us_english_locale" = true;

          # Don't leak private IP address with WebRTC
          "media.peerconnection.ice.default_address_only" = true;
          "media.peerconnection.ice.no_host" = true;

          "media.webspeech.recognition.enable" = false;

          "network.cookie.cookieBehavior" = 1; # Only cookies from the originating server are allowed.
          "network.cookie.thirdparty.sessionOnly" = true; # If we decide to enable them temporarily

          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;

          "network.http.referer.XOriginPolicy" = 2; # Send a referrer only on same-origin

          "network.http.speculative-parallel-limit" = 0;

          "network.IDN_show_punycode" = true;

          "network.manage-offline-status" = false;

          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;

          "privacy.donottrackheader.enabled" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = false;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          # Enable containers
          "privacy.userContext.enabled" = true;

          "security.fileuri.strict_origin_policy" = true;
          "security.mixed_content.block_active_content" = true;
          "security.mixed_content.block_display_content" = true;

          "webgl.min_capability_mode" = true;
          "webgl.disable-extensions" = true;
          "webgl.disable-fail-if-major-performance-caveat" = true;
          "webgl.enable-debug-renderer-info" = false;

          # == Telemetry :( ==

          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = true;

          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;

          "extensions.shield-recipe-client.enabled" = false;
          "extensions.pocket.enabled" = false;

          "loop.logDomains" = false;

          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;

          # == Other Firefox privacy weirdness ==

          # Crash reporting
          "breakpad.reportURL" = "";

          "browser.casting.enabled" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.discovery.enabled" = false; # Firefox add-on recommendations
          "browser.formfill.enable" = false;
          "browser.search.update" = false;
          "browser.pagethumbnails.capturing_disabled" = true;
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.uitour.enabled" = true;
          "browser.urlbar.filter.javascript" = true;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.trimURLs" = false;

          # Discovery of LAN/proximity IoT devices that expose a Web interface
          "dom.flyweb.enabled" = false;

          "experiments.supported" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = false;

          "network.allow-experiments" = false;
          "network.captive-portal-service.enabled" = false;

          "plugin.state.flash" = 0;
          "plugin.state.java" = 0;

          "signon.rememberSignons" = false;
        };

        # Hide tab bar
        userChrome = ''
          #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar {
            opacity: 0;
            pointer-events: none;
          }

          #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
              visibility: collapse !important;
          }
        '';

      };

    };
  };

}
