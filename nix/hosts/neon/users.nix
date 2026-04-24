{ pkgs, ... }:
{
  users.users.harris = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
    # add your own public key here to enable passwordless login
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICh/J0HfRoQ6sRkckkt2jV1zssTVQN1BQu8AgovlTVcs harris@macos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZedVboReAqHpWaexnFYMtv4PyMueczro8a/jMpNAuW harris@neon"
    ];
  };

  programs.zsh.enable = true;
}
