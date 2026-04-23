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
  };

  programs.zsh.enable = true;
}
