{ ... }:
{
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      infisical-db = {
        image = "postgres:18-alpine";
        environment = {
          POSTGRES_USER = "infisical";
          POSTGRES_DB = "infisical";
          POSTGRES_PASSWORD_FILE = "/run/secrets/infisical-db-password";
        };
        volumes = [ "infisical-db:/var/lib/postgresql/data" ];
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
      };

      infisical = {
        image = "infisical/infisical:latest-postgres";
        dependsOn = [
          "infisical-db"
          "infisical-redis"
        ];
        environment = {
          NODE_ENV = "production";
          DB_CONNECTION_URI = "postgresql://infisical@infisical-db/infisical";
          REDIS_URL = "redis://infisical-redis:6379";
          # Secrets below must be set via environment file — do not hardcode
          # ENCRYPTION_KEY, AUTH_SECRET, JWT_* → use sops-nix or load from file
        };
        environmentFiles = [ "/etc/infisical/env" ];
        ports = [ "0.0.0.0:8080:8080" ];
        volumes = [ "infisical-data:/app/.infisical" ];
      };
    };
  };

  # Expose via Tailscale only — no direct public port
}
