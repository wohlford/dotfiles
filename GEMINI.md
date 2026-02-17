# GEMINI.md

This file provides guidance to Gemini when working with code in this repository.

See `.gemini/GEMINI.md` for environment details, tooling preferences, and coding standards.

## Overview

Personal dotfiles for macOS with MacPorts. Configuration files are symlinked from `~/dotfiles` into the home directory.

## Repository Structure

| File | Purpose |
| :--- | :--- |
| `.bash_profile` | Login shell — PATH (MacPorts, Python, GNU coreutils, Claude Code), editor, colors, Vagrant, GPG agent |
| `.bashrc` | Interactive shell — history, prompt, completions, lesspipe |
| `.bash_aliases` | Aliases — color support, shell basics, networking, security, MacPorts, dev tools |
| `.inputrc` | Readline — tab completion, bracketed paste |
| `.gitconfig` | Git — user, signing, aliases, LFS |
| `.gnupg/gpg.conf` | GnuPG — signing key, crypto preferences, display, privacy |
| `.gnupg/gpg-agent.conf` | GPG agent — SSH support, pinentry, cache TTLs |
| `.gnupg/dirmngr.conf` | Keyserver (keys.openpgp.org) |
| `.ssh/config` | SSH — Mozilla OpenSSH Modern crypto, multiplexing, GPG agent |
| `.ssh/config.d/` | Per-host SSH configurations |
| `.tmux.conf.local` | tmux customization (gpakosz/.tmux submodule) |
| `.vimrc` | Vim — indentation, search, undo, line numbers |

## Key Conventions

- Shell execution order: `.bash_profile` → `.bashrc` → `.bash_aliases`
- GNU coreutils on PATH via `/opt/local/libexec/gnubin` — use `--long-options` (not BSD flags)
- GPG agent provides SSH authentication (YubiKey-based keys)
- All commits are signed (`-S`); all tags are signed annotated (`-s -a`)
- `.gitignore` is built incrementally: macOS/editor (v0.0.1), GnuPG runtime (v0.4.0), secrets (v0.6.0)
- `README.md` is built incrementally alongside feature commits
