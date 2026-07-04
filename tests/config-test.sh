#!/usr/bin/env bash
set -uo pipefail

# ============================================================================
# Script: config-test.sh
# Purpose: Regression tests for tracked config content (gpg.conf)
# Usage: ./tests/config-test.sh
# ============================================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPO_DIR

pass_count=0
fail_count=0

pass() { pass_count=$((pass_count + 1)); printf '  ok: %s\n' "$*"; }
fail() { fail_count=$((fail_count + 1)); printf '  FAIL: %s\n' "$*" >&2; }

assert() {
  local desc="$1"
  shift
  if "$@"; then pass "$desc"; else fail "$desc"; fi
}

file_lacks_line() {
  ! grep -q "$2" "$1"
}

test_gpg_conf_policy() {
  printf 'gpg: per-message options are not forced globally\n'
  assert 'throw-keyids is not set globally' \
    file_lacks_line "$REPO_DIR/.gnupg/gpg.conf" '^throw-keyids'
}

main() {
  test_gpg_conf_policy

  printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
