{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # generated with nixos-generate-config on neon, then copied here
    ./hardware-configuration.nix
    ./nvidia.nix
    ./tailscale.nix
    ./syncthing.nix
    ./immich.nix
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

  users.users.harris = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Hyprland (using flake input for latest features)
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

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

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Hyprland binary cache
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
