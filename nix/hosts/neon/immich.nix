{ ... }:
{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 12283;
    openFirewall = false;
    mediaLocation = "/var/lib/immich";
  };

  # PostgreSQL and Redis are managed automatically by the immich module
}
