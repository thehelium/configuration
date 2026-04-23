{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "harris";
    group = "users";
    dataDir = "/home/harris/Sync";
    configDir = "/home/harris/.config/syncthing";
    settings.gui = {
      # listen on all interfaces; firewall trusts tailscale0 only, unreachable from outside
      address = "0.0.0.0:8384";
      insecureSkipHostcheck = true;
    };
  };

  # Syncthing sync ports (must be open externally for direct connections)
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
