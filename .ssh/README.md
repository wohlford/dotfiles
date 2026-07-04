# .ssh

SSH client configuration with modern crypto, connection multiplexing, and GPG agent integration.

## Contents

| File | Description |
| :--- | :--- |
| `config` | Global SSH client config — modern OpenSSH default crypto with legacy SHA-1/MD5 banned, multiplexing, agent forwarding |
| `config.d/` | Per-host configuration fragments included by `config` (`Include config.d/*.conf`) |
| `authorized_keys` | Public keys authorized for inbound SSH to this host |
| `id_rsa_yubikey_*.pub` | Public keys for YubiKey-backed SSH authentication keys |
| `masters/` | ControlMaster socket directory for connection multiplexing |

## Notes

- Crypto rides the current OpenSSH client defaults (which include post-quantum key exchange on OpenSSH 9.9+) and subtracts only legacy SHA-1/MD5 algorithms — the retired frozen-list approach (Mozilla OpenSSH Modern, 2015) silently aged out of both new algorithms and SHA-2 RSA host keys. A legacy device gets its algorithms back per-host in `config.d` with the `+` form (example in `config.d/hosts.conf`).
- Private keys are stored on YubiKeys; the GPG agent (`enable-ssh-support` in `~/.gnupg/gpg-agent.conf`) serves them via the SSH protocol.
- ControlMaster sockets persist for 4 hours to speed up subsequent connections to the same host.
- Drop per-host configuration into `config.d/*.conf` rather than editing `config` directly.
