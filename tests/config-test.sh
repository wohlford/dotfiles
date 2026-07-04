#!/usr/bin/env bash
set -uo pipefail

# ============================================================================
# Script: config-test.sh
# Purpose: Regression tests for tracked config content (.ssh/config, gpg.conf)
# Usage: ./tests/config-test.sh
# ============================================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPO_DIR

WORK_DIR="$(mktemp -d)"
readonly WORK_DIR
trap 'rm -rf "$WORK_DIR"' EXIT

RESOLVED=''
pass_count=0
fail_count=0

pass() { pass_count=$((pass_count + 1)); printf '  ok: %s\n' "$*"; }
fail() { fail_count=$((fail_count + 1)); printf '  FAIL: %s\n' "$*" >&2; }

assert() {
  local desc="$1"
  shift
  if "$@"; then pass "$desc"; else fail "$desc"; fi
}

# ssh -G resolution of the tracked config against an empty include dir,
# so machine-local ~/.ssh/config.d files never influence the result
resolve_ssh_config() {
  mkdir -p "$WORK_DIR/config.d"
  sed "s|^Include config.d/\*.conf|Include $WORK_DIR/config.d/*.conf|" \
    "$REPO_DIR/.ssh/config" > "$WORK_DIR/config"
  RESOLVED="$(ssh -F "$WORK_DIR/config" -G example.com 2>/dev/null)"
}

# The named ssh -G list ("hostkeyalgorithms") contains this exact algorithm
offers() {
  local key="$1" algo="$2"
  grep "^$key " <<< "$RESOLVED" | grep -Eq "(^$key |,)$algo(,|\$)"
}

# The named ssh -G list matches this pattern nowhere
list_lacks() {
  local key="$1" pattern="$2"
  ! grep "^$key " <<< "$RESOLVED" | grep -Eq "$pattern"
}

file_lacks_line() {
  ! grep -q "$2" "$1"
}

test_ssh_crypto_policy() {
  printf 'ssh: legacy algorithms banned, modern defaults intact\n'
  resolve_ssh_config
  assert 'config parses under ssh -G' test -n "$RESOLVED"
  assert 'SHA-1 host key algo ssh-rsa is not offered' \
    list_lacks hostkeyalgorithms '(^hostkeyalgorithms |,)ssh-rsa(,|$)'
  assert 'SHA-2 RSA host keys still allowed (rsa-sha2-512)' \
    offers hostkeyalgorithms 'rsa-sha2-512'
  assert 'ed25519 host keys still allowed' \
    offers hostkeyalgorithms 'ssh-ed25519'
  assert 'post-quantum KEX is offered (mlkem768x25519-sha256)' \
    offers kexalgorithms 'mlkem768x25519-sha256'
  assert 'no SHA-1 KEX offered' list_lacks kexalgorithms 'sha1'
  assert 'no SHA-1 or MD5 MACs offered' list_lacks macs 'sha1|md5'
}

test_gpg_conf_policy() {
  printf 'gpg: per-message options are not forced globally\n'
  assert 'throw-keyids is not set globally' \
    file_lacks_line "$REPO_DIR/.gnupg/gpg.conf" '^throw-keyids'
}

main() {
  test_ssh_crypto_policy
  test_gpg_conf_policy

  printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
