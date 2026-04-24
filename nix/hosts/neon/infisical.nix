{ ... }:
{
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      infisical-db = {
        image = "postgres:18-alpine";
        environmentFiles = [ "/etc/infisical/db.env" ];
        volumes = [ "infisical-db:/var/lib/postgresql" ];
        extraOptions = [ "--network=infisical" ];
      };

      infisical-redis = {
        image = "redis:8-alpine";
        cmd = [
          "redis-server"
          "--save"
          "60"
          "1"
        ];
        volumes = [ "infisical-redis:/data" ];
        extraOptions = [ "--network=infisical" ];
      };

      infisical = {
        image = "infisical/infisical:latest-postgres";
        dependsOn = [
          "infisical-db"
          "infisical-redis"
        ];
        environment = {
          NODE_ENV = "production";
          REDIS_URL = "redis://infisical-redis:6379";
        };
        environmentFiles = [ "/etc/infisical/env" ];
        ports = [ "0.0.0.0:8080:8080" ];
        volumes = [ "infisical-data:/app/.infisical" ];
        extraOptions = [ "--network=infisical" ];
      };
    };
  };

  systemd.services."podman-infisical-db" = {
    preStart = ''
      podman network inspect infisical >/dev/null 2>&1 || podman network create infisical
    '';
  };

  # Expose via Tailscale only — no direct public port
}
