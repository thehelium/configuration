{ pkgs, ... }:
{
  imports = [
    # generated with nixos-generate-config on neon, then copied here
    ./hardware-configuration.nix
    ./users.nix
    ./desktop.nix
    ./nvidia.nix
    ./tailscale.nix
    ./syncthing.nix
    ./immich.nix
    ./seaweedfs.nix
    ./infisical.nix
  ];

  networking = {
    hostName = "neon";
    networkmanager.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;
  programs.nix-ld.enable = true;

  # Podman: daemonless container runtime, docker-compatible (for dev databases, etc.)
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
