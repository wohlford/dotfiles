#!/usr/bin/env bash
set -uo pipefail

# ============================================================================
# Script: install-test.sh
# Purpose: Regression tests for install.sh (sandboxed; never touches real $HOME)
# Usage: ./tests/install-test.sh
# ============================================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPO_DIR

WORK_DIR="$(mktemp -d)"
readonly WORK_DIR
trap 'rm -rf "$WORK_DIR"' EXIT

pass_count=0
fail_count=0

pass() { pass_count=$((pass_count + 1)); printf '  ok: %s\n' "$*"; }
fail() { fail_count=$((fail_count + 1)); printf '  FAIL: %s\n' "$*" >&2; }

assert() {
  local desc="$1"
  shift
  if "$@"; then pass "$desc"; else fail "$desc"; fi
}

# Build a minimal fixture repo: install.sh plus every file it links.
make_fixture() {
  local fx="$1"
  mkdir -p "$fx/.gnupg" "$fx/.ssh/config.d" "$fx/.vim/undo"
  cp "$REPO_DIR/install.sh" "$fx/install.sh"
  chmod +x "$fx/install.sh"
  local f
  for f in .bash_profile .bashrc .bash_aliases .inputrc .gitconfig .vimrc; do
    printf '# fixture %s\n' "$f" > "$fx/$f"
  done
  for f in gpg.conf gpg-agent.conf dirmngr.conf; do
    printf '# fixture %s\n' "$f" > "$fx/.gnupg/$f"
  done
  printf '# fixture ssh config\n' > "$fx/.ssh/config"
  touch "$fx/.vim/undo/.gitkeep"
}

# Run the fixture install with an isolated HOME; echoes combined output
run_install() {
  local fx="$1" home="$2"
  mkdir -p "$home"
  HOME="$home" bash "$fx/install.sh" 2>&1
}

test_happy_path_links_core_files() {
  printf 'happy path: fresh HOME gets core symlinks\n'
  local fx="$WORK_DIR/t1/repo" home="$WORK_DIR/t1/home"
  make_fixture "$fx"
  run_install "$fx" "$home" > /dev/null
  assert 'exit status 0' test "$?" -eq 0
  local f
  for f in .bash_profile .bashrc .vimrc; do
    assert "$f is a symlink into the fixture" test "$(readlink "$home/$f")" = "$fx/$f"
  done
}

test_backup_never_clobbered() {
  printf 'backup: a pre-existing .bak survives a re-run\n'
  local fx="$WORK_DIR/t2/repo" home="$WORK_DIR/t2/home"
  make_fixture "$fx"
  mkdir -p "$home"
  printf 'ORIGINAL A\n' > "$home/.bashrc"
  run_install "$fx" "$home" > /dev/null
  # an editor safe-save breaks the symlink, leaving a new real file
  rm "$home/.bashrc"
  printf 'NEWER B\n' > "$home/.bashrc"
  run_install "$fx" "$home" > /dev/null
  assert 'original backup content still exists somewhere' \
    grep -rq 'ORIGINAL A' "$home"
}

test_relink_reports_old_target() {
  printf 'relink: repointing a foreign symlink names the old target\n'
  local fx="$WORK_DIR/t3/repo" home="$WORK_DIR/t3/home"
  make_fixture "$fx"
  mkdir -p "$home/elsewhere-dir"
  printf 'old vimrc\n' > "$home/elsewhere-dir/vimrc"
  ln -s "$home/elsewhere-dir/vimrc" "$home/.vimrc"
  local out
  out="$(run_install "$fx" "$home")"
  assert 'output mentions the previous symlink target' \
    grep -q 'elsewhere-dir' <<< "$out"
}

test_idempotent_rerun() {
  printf 'idempotency: second run changes nothing and exits 0\n'
  local fx="$WORK_DIR/t8/repo" home="$WORK_DIR/t8/home"
  make_fixture "$fx"
  run_install "$fx" "$home" > /dev/null
  local before after
  before="$(find "$home" | sort)"
  run_install "$fx" "$home" > /dev/null
  assert 'second run exits 0' test "$?" -eq 0
  after="$(find "$home" | sort)"
  assert 'no files appear or vanish on re-run' test "$before" = "$after"
}

test_ssh_masters_dir_created() {
  printf 'ssh: ControlPath directory ~/.ssh/masters exists after install\n'
  local fx="$WORK_DIR/t6/repo" home="$WORK_DIR/t6/home"
  make_fixture "$fx"
  run_install "$fx" "$home" > /dev/null
  assert 'HOME/.ssh/masters is a directory' test -d "$home/.ssh/masters"
}

test_missing_pinentry_warns() {
  printf 'gpg: a nonexistent configured pinentry produces a warning\n'
  local fx="$WORK_DIR/t9/repo" home="$WORK_DIR/t9/home"
  make_fixture "$fx"
  printf 'pinentry-program /nonexistent/pinentry-mac\n' > "$fx/.gnupg/gpg-agent.conf"
  local out
  out="$(run_install "$fx" "$home")"
  assert 'install exits 0 (warning is non-fatal)' test "$?" -eq 0
  assert 'output warns about the missing pinentry' \
    grep -qi 'pinentry not found' <<< "$out"
}

test_gitignore_guards_leak_paths() {
  printf 'gitignore: leak-prone paths in the real repo are ignored\n'
  local p
  for p in '.ssh/config.d/stray-host.conf' '.vim/undo/%Users%jason%file'; do
    assert "git ignores $p" git -C "$REPO_DIR" check-ignore -q "$p"
  done
  assert 'tracked hosts.conf stays tracked (not newly ignored)' \
    test -n "$(git -C "$REPO_DIR" ls-files .ssh/config.d/hosts.conf)"
}

main() {
  test_happy_path_links_core_files
  test_backup_never_clobbered
  test_relink_reports_old_target
  test_ssh_masters_dir_created
  test_idempotent_rerun
  test_missing_pinentry_warns
  test_gitignore_guards_leak_paths

  printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
