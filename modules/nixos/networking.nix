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
              interface-name = "enp0s26u1u2";
            };

            ipv4 = {
              method = "manual";
              addresses = "192.168.68.50/24";
              gateway = "192.168.68.1";
              dns = "127.0.0.1";
            };

            ipv6 = {
              method = "disabled";
            };
          };

          "AdGuard WiFi" = {
            connection = {
              id = "AdGuard WiFi";
              type = "wifi";
              interface-name = "wlp0s20u4";
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
              method = "manual";
              addresses = "192.168.68.50/24";
              gateway = "192.168.68.1";
              dns = "127.0.0.1";
            };

            ipv6 = {
              method = "auto";
            };
          };
        };
      };
    };

    nameservers = [
      "127.0.0.1"
    ];

    firewall = {
      allowedTCPPorts = [
        53
        3003
      ];

      allowedUDPPorts = [
        53
      ];
    };
  };

  services.adguardhome = {
    enable = true;

    # Web interface:
    # http://localhost:3003
    host = "127.0.0.1";
    port = 3003;

    settings = {
      dns = {
        # Listen for DNS requests from the LAN.
        bind_hosts = [
          "127.0.0.1"
        ];

        # Standard DNS port.
        port = 53;

        # Upstream DNS servers.
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
