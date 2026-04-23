{ config, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall = {
    # Tailscale handshake port
    allowedUDPPorts = [ config.services.tailscale.port ];
    # trust all traffic within the Tailscale network (Immich, Syncthing GUI, etc. route through here)
    trustedInterfaces = [ "tailscale0" ];
  };

  # after activation, run manually: sudo tailscale up
}
