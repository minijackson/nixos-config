{ config, pkgs, lib, ... }:

{
  networking.firewall.allowPing = true;

  networking.networkmanager = {
    enable = config.hardware.isLaptop;
    dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      static = {
        "ns3.fr.dns.opennic.glue iriseden DNSCrypt IPv4".stamp =
          "sdns://AQcAAAAAAAAAEzYyLjIxMC4xNzcuMTg5OjEwNTMgW8vytBGk6u3kvCpl4q88XjqW-w6JJiJ7QBObcFV7gYAfMi5kbnNjcnlwdC1jZXJ0Lm5zMS5pcmlzZWRlbi5mcg";
        "ns3.fr.dns.opennic.glue iriseden DNSCrypt IPv6".stamp =
          "sdns://AQcAAAAAAAAAHVsyMDAxOmJjODozMmQ3OjMwODo6MjAxXToxMDUzIEUAcwKTPY6tyEQxtfO3rIzEyqN9w7WGPLz7ZsHsx5EGHzIuZG5zY3J5cHQtY2VydC5uczEuaXJpc2VkZW4uZnI";
        "ns3.fr.dns.opennic.glue iriseden DoH".stamp =
          "sdns://AgcAAAAAAAAAAAAPbnMxLmlyaXNlZGVuLmV1CWRucy1xdWVyeQ";

        "ns4.fr.dns.opennic.glue iriseden DNSCrypt IPv4".stamp =
          "sdns://AQcAAAAAAAAAEjYyLjIxMC4xODAuNzE6MTA1MyBxLWt8kNHoMqM7vKXCkuZ3PnB32c0qV2I3KGQYtlDKSB8yLmRuc2NyeXB0LWNlcnQubnMyLmlyaXNlZGVuLmZy";
        "ns4.fr.dns.opennic.glue iriseden DNSCrypt IPv6".stamp =
          "sdns://AQcAAAAAAAAAHVsyMDAxOmJjODozMmQ3OjMwNzo6MzAxXToxMDUzIJjeEela3WTzMuuZTskr7aOchIg2llSDNRsHfcggITn6HzIuZG5zY3J5cHQtY2VydC5uczIuaXJpc2VkZW4uZnI";
        "ns4.fr.dns.opennic.glue iriseden DoH".stamp =
          "sdns://AgcAAAAAAAAAAAAPbnMyLmlyaXNlZGVuLmV1CWRucy1xdWVyeQ";

        "ns8.he.de.dns.opennic.glue ethservices DoH".stamp =
          "sdns://AgcAAAAAAAAAAAAcb3Blbm5pYzEuZXRoLXNlcnZpY2VzLmRlOjg1MwA";

        "ns31.de.dns.opennic.glue ethservices DoH".stamp =
          "sdns://AgcAAAAAAAAAAAAcb3Blbm5pYzIuZXRoLXNlcnZpY2VzLmRlOjg1MwA";

        "ns3.de.dns.opennic.glue Eleix DoH".stamp =
          "sdns://AgcAAAAAAAAAAAAQZG9oLmJvb3RobGFicy5tZQlkbnMtcXVlcnk";
      };

      cloaking_rules = with lib;
      let
        inherit (config.networking) hosts;
        entryToCloak = addr:
          concatMapStringsSep "\n" (hostname: "${hostname} ${addr}") hosts.${addr};
      in builtins.toFile
        "cloaking-rules.txt"
        (concatMapStringsSep "\n" entryToCloak (attrNames config.networking.hosts));
    };
  };

  networking.resolvconf.useLocalResolver = true;
}
