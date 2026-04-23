# configuration

Personal dotfiles for macOS and NixOS, managed via [Home Manager](https://github.com/nix-community/home-manager).

## Structure

```
configuration/
├── zsh/          # Zsh config (env, aliases, prompt, fzf, widgets, functions)
├── tmux/         # Tmux config + status bar scripts
├── nix/          # Nix flake + Home Manager (home.nix, NixOS hosts)
└── iterm2/       # iTerm2 preferences (com.googlecode.iterm2.plist)
```

## Setup

### Option A — Clone as `~/.config`

The repo root becomes `~/.config`, so all subdirectories land in the correct locations with no extra steps.

```bash
# Back up existing ~/.config first
mv ~/.config ~/.config.bak

git clone https://github.com/thehelium/configuration.git ~/.config

# Restore anything you need from the backup
cp -r ~/.config.bak/some-app ~/.config/some-app
```

### Option B — Clone anywhere

Clone to any directory and run `install.sh` to create symlinks from `~/.config/<module>` to the corresponding directory in the repo. Existing directories are backed up automatically (e.g. `zsh.bak.20240423120000`).

```bash
git clone https://github.com/thehelium/configuration.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Home Manager (Nix)

On systems with Nix installed, Home Manager generates `~/.zshrc` from `nix/home.nix`. After setup, apply the config with:

```bash
# Full command
nix run '/path/to/nix#homeConfigurations."harris@aarch64-darwin".activationPackage'

# Or use the shell alias
hms
```

## iTerm2

iTerm2 reads and writes its preferences directly to `iterm2/` in this repo.

To set this up on a new machine:

1. Open iTerm2 → **Settings** → **General** → **Preferences**
2. Check **Load settings from a custom folder or URL**
3. Set the path to the `iterm2/` directory in this repo
4. Check **Save changes to folder when iTerm2 quits**

Changes to iTerm2 settings are written back to `iterm2/com.googlecode.iterm2.plist` automatically on quit — just `git commit` and push to sync.

## Platforms

| Module | macOS | NixOS |
|--------|-------|-------|
| zsh    | ✓     | ✓     |
| tmux   | ✓     | ✓     |
| nix    | ✓ (Home Manager) | ✓ (NixOS + Home Manager) |
| iterm2 | ✓     | —     |
