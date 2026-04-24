{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "harris";
    group = "users";
    dataDir = "/home/harris/Sync";
    configDir = "/home/harris/.config/syncthing";
    # guiAddress overrides the existing config file (settings.gui.address does not)
    guiAddress = "0.0.0.0:8384";
    settings.gui.insecureSkipHostcheck = true;
  };

  # Syncthing sync ports (must be open externally for direct connections)
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
