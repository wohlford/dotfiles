# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

See `~/.claude/CLAUDE.md` for environment details, tooling preferences, and coding standards.

## Overview

Personal dotfiles for macOS with MacPorts. Configuration files are symlinked from `~/dotfiles` into the home directory.

## Repository Structure

| File | Purpose |
| :--- | :--- |
| `.bash_profile` | Login shell — PATH (MacPorts, Python, GNU coreutils, Claude Code), editor, colors, Vagrant, GPG agent |
| `.bashrc` | Interactive shell — history, prompt, completions, lesspipe |
| `.bash_aliases` | Aliases — color support, shell basics, networking, security, MacPorts, dev tools |
| `.bash_aliases.local.example` | Template for machine-local shell aliases (`~/.bash_aliases.local`, gitignored) |
| `.inputrc` | Readline — tab completion, bracketed paste |
| `.gitconfig` | Git — user, signing, aliases, LFS |
| `.gitconfig.local.example` | Template for machine-local git overrides (`~/.gitconfig.local`, gitignored) |
| `.gnupg/gpg.conf` | GnuPG — signing key, crypto preferences, display, privacy |
| `.gnupg/gpg-agent.conf` | GPG agent — SSH support, pinentry, cache TTLs |
| `.gnupg/dirmngr.conf` | Keyserver (keys.openpgp.org) |
| `.ssh/config` | SSH — modern OpenSSH default crypto with legacy SHA-1/MD5 banned, multiplexing, GPG agent |
| `.ssh/config.d/` | Per-host SSH configurations |
| `.tmux.conf.local` | tmux customization (gpakosz/.tmux submodule) |
| `.vimrc` | Vim — indentation, search, undo, line numbers |
| `tests/install-test.sh` | Sandboxed regression tests for `install.sh` (fixture repo + isolated `$HOME`) |
| `tests/config-test.sh` | Regression tests for tracked config content (SSH crypto policy, gpg.conf) |

## Key Conventions

- Shell execution order: `.bash_profile` → `.bashrc` → `.bash_aliases`
- Deploy with `./install.sh` — symlinks tracked files into `$HOME`, backs up any existing real file to `<name>.bak` (never clobbers an earlier backup — falls back to a timestamped name), and inits submodules best-effort (a failed or empty submodule skips that link, never the core files); idempotent, re-run safely; regression tests: `./tests/install-test.sh`
- GNU coreutils on PATH via `/opt/local/libexec/gnubin` — use `--long-options` (not BSD flags)
- GPG agent provides SSH authentication (YubiKey-based keys)
- `~/.gitconfig` is symlinked from this repo, so tools that write to it (e.g. `gh auth login`) dirty the tracked `.gitconfig`; with `pull.rebase = true` a dirty tree blocks `git pull` — put per-machine git settings in `~/.gitconfig.local` (gitignored, loaded via `[include]`), see `.gitconfig.local.example`
- Machine-local overrides follow one pattern (all gitignored): `~/.gitconfig.local` (git `[include]`) and `~/.bash_aliases.local` (sourced last by `.bash_aliases`), each with a tracked `.example`; and `~/.ssh/config.d/*.conf` (SSH `Include`) — repo-side `.ssh/config.d/*.conf` strays are gitignored too, with only the tracked `hosts.conf` template excepted
- SSH deploys differently from the symlinked dotfiles: `install.sh` symlinks `~/.ssh/config` but `~/.ssh/config.d/` is a machine-local dir (NOT symlinked); files there override the tracked `Host *` base because `Include config.d/*.conf` is line 1 and SSH is first-match-wins — for single-valued options only; multi-valued ones (`IdentityFile`, `SendEnv`, forwardings) accumulate instead, so pin a key with `IdentitiesOnly yes` in the host block
- `.gitconfig` is indented with tabs (git's canonical format) — outside STYLE's 2-space rule; don't reformat it
- Signing is config-driven: `commit.gpgsign`/`tag.gpgsign` are `true`, so plain `git commit` / `git tag -a` sign automatically — never pass `-S`/`-s`
- `.ssh/config` crypto is subtract-only: ride modern OpenSSH defaults and ban legacy (`-ssh-rsa`, `-*-sha1`); never freeze algorithm allowlists (they rot — the 2015 Mozilla list had aged out SHA-2 RSA and post-quantum KEX). Old boxes get per-host `+` re-adds in `config.d` (example in `hosts.conf`)
- Changes to `install.sh` or tracked config content are test-first: extend `tests/install-test.sh` / `tests/config-test.sh` (sandboxed fixture + isolated `$HOME`, never the real one) and run both before committing
- Submodules are pinned by gitlink (`.claude` → dotclaude, `.gemini` → dotgemini, `.tmux` → gpakosz); bump deliberately via a `chore(<path>)` commit — `install.sh` inits them best-effort and never links an empty checkout
- `.gitignore` is built incrementally: macOS/editor (v0.0.1), GnuPG runtime (v0.4.0), secrets (v0.6.0)
- `README.md` is built incrementally alongside feature commits
