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
    fd
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
  ] ++ lib.optionals stdenv.isLinux [ zimfw ];

  home.file.".zimrc" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      zmodule magicmace

      zmodule environment
      zmodule git
      zmodule input
      zmodule termtitle
      zmodule utility
      zmodule completion
      zmodule git-info
      zmodule duration-info
      zmodule prompt-pwd
      zmodule zsh-users/zsh-completions
      zmodule zsh-users/zsh-autosuggestions
      zmodule zsh-users/zsh-history-substring-search
      zmodule zdharma-continuum/fast-syntax-highlighting
      zmodule supercrabtree/k
      zmodule hlissner/zsh-autopair
      zmodule pabloariasal/zfm
      zmodule agkozak/zsh-z
      zmodule Aloxaf/fzf-tab
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false; # Zim handles fzf integration via fzf-tab
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    defaultOptions = [ "--height 50%" "--layout=default" "--border" "--color=hl:#2dd4bf" ];
    fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetOptions = [ "--preview 'bat --color=always -n --line-range :500 {}'" ];
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    changeDirWidgetOptions = [ "--preview 'eza --tree --color=always | head -200'" ];
  };

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
    + lib.optionalString pkgs.stdenv.isLinux ''
      # Zim framework (installed via nix)
      ZIM_HOME=''${ZDOTDIR:-''${HOME}}/.zim
      if [[ ! -e ''${ZIM_HOME}/init.zsh ]]; then
        source ${pkgs.zimfw}/zimfw.zsh install
      elif [[ ! ''${ZIM_HOME}/init.zsh -nt ''${ZDOTDIR:-''${HOME}}/.zimrc ]]; then
        source ${pkgs.zimfw}/zimfw.zsh init
      fi
      source ''${ZIM_HOME}/init.zsh

      # fzf keybindings (ctrl+r, ctrl+t, alt+c) — after Zim to avoid early compinit
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh

      source /home/harris/configuration/zsh/env.zsh
      source /home/harris/configuration/zsh/aliases.zsh
      source /home/harris/configuration/zsh/fzf.zsh
      source /home/harris/configuration/zsh/prompt.zsh
      source /home/harris/configuration/zsh/functions/rcode.zsh
      source /home/harris/configuration/zsh/functions/dotenv.zsh
      source /home/harris/configuration/zsh/functions/ssh.zsh
      source /home/harris/configuration/zsh/widgets/lazygit.zsh
      source /home/harris/configuration/zsh/widgets/smart_e.zsh
    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
      # Zim framework (installed via Homebrew)
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
      source ~/.config/zsh/functions/ssh.zsh
      source ~/.config/zsh/widgets/lazygit.zsh
      source ~/.config/zsh/widgets/smart_e.zsh
    '';
  };

  programs.home-manager.enable = true;
}
