#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Modules: repo subdirectory -> symlink target under $CONFIG_DIR
MODULES=(
    zsh
    tmux
    nix
)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()   { echo -e "${GREEN}  ✓${NC} $*"; }
warn()   { echo -e "${YELLOW}  !${NC} $*"; }
error()  { echo -e "${RED}  ✗${NC} $*"; }

link_module() {
    local name="$1"
    local src="$REPO_DIR/$name"
    local dst="$CONFIG_DIR/$name"

    if [[ ! -e "$src" ]]; then
        warn "skip $name: source not found ($src)"
        return
    fi

    # Already linked to the correct target
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        info "$name → already linked, skipping"
        return
    fi

    # Existing symlink pointing elsewhere
    if [[ -L "$dst" ]]; then
        warn "$name → replacing old symlink ($(readlink "$dst"))"
        rm "$dst"
    fi

    # Existing real directory/file — back it up
    if [[ -e "$dst" ]]; then
        local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        warn "$name → backing up existing to $(basename "$backup")"
        mv "$dst" "$backup"
    fi

    ln -s "$src" "$dst"
    info "$name → $dst"
}

echo ""
echo "configuration install"
echo "  repo   : $REPO_DIR"
echo "  config : $CONFIG_DIR"
echo ""

mkdir -p "$CONFIG_DIR"

for module in "${MODULES[@]}"; do
    link_module "$module"
done

echo ""
echo "Done. Open a new shell or run: source ~/.zshrc"
echo ""
