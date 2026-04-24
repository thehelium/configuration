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
    allowedTCPPorts = [ 80 443 2283 8384 ]; # 2283/8384 for Caddy HTTPS virtual hosts
  };

  services.caddy = {
    enable = true;
    virtualHosts."neon.tail797dae.ts.net" = {
      extraConfig = ''
        tls /var/lib/caddy/certs/neon.tail797dae.ts.net.crt /var/lib/caddy/certs/neon.tail797dae.ts.net.key
        reverse_proxy localhost:8080
      '';
    };
    virtualHosts."neon.tail797dae.ts.net:2283" = {
      extraConfig = ''
        tls /var/lib/caddy/certs/neon.tail797dae.ts.net.crt /var/lib/caddy/certs/neon.tail797dae.ts.net.key
        reverse_proxy localhost:12283
      '';
    };
    virtualHosts."neon.tail797dae.ts.net:8384" = {
      extraConfig = ''
        tls /var/lib/caddy/certs/neon.tail797dae.ts.net.crt /var/lib/caddy/certs/neon.tail797dae.ts.net.key
        reverse_proxy localhost:18384
      '';
    };
  };

  systemd.services.caddy = {
    after = [ "tailscale-cert.service" ];
    requires = [ "tailscale-cert.service" ];
  };

  # Automatically renew Tailscale HTTPS certificate
  systemd.services.tailscale-cert = {
    description = "Renew Tailscale TLS certificate";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /var/lib/caddy/certs";
      ExecStart = "/run/current-system/sw/bin/tailscale cert --cert-file /var/lib/caddy/certs/neon.tail797dae.ts.net.crt --key-file /var/lib/caddy/certs/neon.tail797dae.ts.net.key neon.tail797dae.ts.net";
      ExecStartPost = "/run/current-system/sw/bin/chown -R caddy:caddy /var/lib/caddy/certs";
    };
  };

  systemd.timers.tailscale-cert = {
    description = "Renew Tailscale TLS certificate periodically";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  # after activation, run manually: sudo tailscale up
}
