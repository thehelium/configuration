{ ... }:
{
  services.immich = {
    enable = true;
    # listen on all interfaces; firewall trusts tailscale0 only, unreachable from outside
    host = "0.0.0.0";
    port = 2283;
    openFirewall = true;
    mediaLocation = "/var/lib/immich";
  };

  # PostgreSQL and Redis are managed automatically by the immich module
}
