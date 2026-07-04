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
  .vimrc
)

# ---------- Helper Functions ----------
log_info()  { printf '[INFO] %s\n' "$*"; }
log_error() { printf '[ERROR] %s\n' "$*" >&2; }

link_file() {
  local src="$1"
  local dest="$2"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      return 0
    fi
    log_info "Relinking $dest (was → $current)"
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    local bak="${dest}.bak"
    if [[ -e "$bak" || -L "$bak" ]]; then
      # never clobber an earlier backup
      bak="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    fi
    log_info "Backing up $dest → $bak"
    mv "$dest" "$bak"
  fi

  ln -sf "$src" "$dest"
  log_info "Linked $dest → $src"
}

# ---------- Main ----------
main() {
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
  # gpg-agent.conf pins an absolute pinentry path; warn if this box lacks it
  local pinentry
  pinentry="$(awk '/^pinentry-program /{print $2}' "$SCRIPT_DIR/.gnupg/gpg-agent.conf")"
  if [[ -n "$pinentry" && ! -x "$pinentry" ]]; then
    log_error "pinentry not found at $pinentry — gpg passphrase prompts will fail"
  fi

  # Vim undo directory
  mkdir -p "$HOME/.vim"
  link_file "$SCRIPT_DIR/.vim/undo" "$HOME/.vim/undo"

  log_info "Done"
}

main "$@"
