{ config, pkgs, ... }:

{
  networking = {
    hostName = "HP-PC";

    networkmanager = {
      enable = true;
      dns = "none";
      ensureProfiles = {
        environmentFiles = [
          "/etc/NetworkManager/secrets.env"
        ];
        profiles = {
          "AdGuard Ethernet" = {
            connection = {
              id = "AdGuard Ethernet";
              type = "ethernet";
            };

            ipv4 = {
              method = "auto";
            };

            ipv6 = {
              method = "disabled";
            };
          };

          "AdGuard WiFi" = {
            connection = {
              id = "AdGuard WiFi";
              type = "wifi";
            };

            wifi = {
              mode = "infrastructure";
              ssid = "Dev Brijesh";
            };

            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$ADGUARD_WIFI_PASSWORD";
            };

            ipv4 = {
              method = "auto";
            };

            ipv6 = {
              method = "disabled";
            };
          };
        };
      };
    };

    nameservers = [
      "127.0.0.1"
    ];
  };

  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3003;

    settings = {
      dns = {
        bind_hosts = [
          "127.0.0.1"
        ];

        port = 53;

        upstream_dns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false;

        safe_search = {
          enabled = false;
        };
      };

      filters = map (url: {
        enabled = true;
        url = url;
      }) [
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt"
	"https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
	"https://adguardteam.github.io/HostlistsRegistry/assets/filter_5.txt"
      ];
    };
  };
}
