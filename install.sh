#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Script: install.sh
# Purpose: Symlink dotfiles into the home directory
# Usage: ./install.sh
# ============================================================================

# ---------- Configuration ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

# Files symlinked directly into ~
readonly HOME_FILES=(
  .bash_profile
  .bashrc
  .bash_aliases
  .inputrc
  .gitconfig
  .tmux.conf.local
)

# ---------- Helper Functions ----------
log_info()  { echo "[INFO] $*"; }
log_error() { echo "[ERROR] $*" >&2; }

link_file() {
  local src="$1"
  local dest="$2"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      return 0
    fi
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    log_info "Backing up $dest → ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
  log_info "Linked $dest → $src"
}

# ---------- Main ----------
main() {

  # Submodules
  git -C "$SCRIPT_DIR" submodule update --init --recursive

  # Claude Code
  link_file "$SCRIPT_DIR/.claude" "$HOME/.claude"

  # Gemini
  link_file "$SCRIPT_DIR/.gemini" "$HOME/.gemini"

  # Home directory files
  for f in "${HOME_FILES[@]}"; do
    link_file "$SCRIPT_DIR/$f" "$HOME/$f"
  done

  # GnuPG
  mkdir -p "$HOME/.gnupg"
  chmod 700 "$HOME/.gnupg"
  for f in gpg.conf gpg-agent.conf dirmngr.conf; do
    link_file "$SCRIPT_DIR/.gnupg/$f" "$HOME/.gnupg/$f"
  done

  # SSH
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  link_file "$SCRIPT_DIR/.ssh/config" "$HOME/.ssh/config"

  # tmux
  link_file "$SCRIPT_DIR/.tmux" "$HOME/.tmux"

  log_info "Done"
}

main
