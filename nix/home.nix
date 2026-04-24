{ pkgs, lib, ... }:
{
  home.username = "harris";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/harris" else "/home/harris";
  home.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    tmux
    claude-code
    eza
    bat
    ripgrep
    fzf
    yazi
    fastfetch
    nixfmt
    go
    bun
    uv
    lazygit
    wget
    ffmpeg
    rclone
    infisical
    zimfw
  ];

  programs.zsh = {
    enable = true;
    completionInit = ""; # Zim handles compinit
    shellAliases = {
      ls = "eza";
      cat = "bat";
      lg = "lazygit";
    };
    initContent = ''
      # Home Manager rebuild
      function hms() {
        local flake
        flake="$(readlink -f ~/.config/nix 2>/dev/null || echo ~/.config/nix)"
        local system
        system="$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')"
        case "$system" in
          arm64-darwin|aarch64-darwin) system="aarch64-darwin" ;;
          x86_64-linux)                system="x86_64-linux"   ;;
        esac
        nix run "$flake#homeConfigurations.\"harris@$system\".activationPackage"
      }

      # yazi cd-on-exit wrapper
      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    ''
    + ''
      # Zim framework (via nixpkgs)
      ZIM_HOME=''${ZDOTDIR:-''${HOME}}/.zim
      if [[ ! ''${ZIM_HOME}/init.zsh -nt ''${ZIM_CONFIG_FILE:-''${ZDOTDIR:-''${HOME}}/.zimrc} ]]; then
        source ${pkgs.zimfw}/share/zimfw.zsh init
      fi
      source ''${ZIM_HOME}/init.zsh

      # Custom zsh configs
      source ~/.config/zsh/env.zsh
      source ~/.config/zsh/aliases.zsh
      source ~/.config/zsh/fzf.zsh

      autopair-init
      source ~/.zim/modules/fzf-tab/fzf-tab.plugin.zsh

      source ~/.config/zsh/prompt.zsh
      source ~/.config/zsh/functions/rcode.zsh
      source ~/.config/zsh/functions/dotenv.zsh
      source ~/.config/zsh/widgets/lazygit.zsh
      source ~/.config/zsh/widgets/smart_e.zsh
    '';
  };

  programs.home-manager.enable = true;
}
