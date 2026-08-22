{ config, pkgs, inputs, ... }:

{

  services.adguardhome = {
    enable = true;
    # Listens on all interfaces so local devices can reach the web UI
    host = "0.0.0.0";
    port = 3003;

    settings = {
      dns = {
        # Bind to port 53 so AdGuard handles actual DNS queries for the network
        bind_hosts = [ "0.0.0.0" ];
        port = 53;

        upstream_dns = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
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

      filters = map (url: { enabled = true; url = url; }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
        "https://big.oisd.nl"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_20.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt"
      ];
    };
  };

  # Open necessary firewall ports for the Web Interface and DNS queries
  networking.firewall = {
    allowedTCPPorts = [ 3003 53 ];
    allowedUDPPorts = [ 53 ];
  };
  
}
