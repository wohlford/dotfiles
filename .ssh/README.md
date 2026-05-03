# .ssh

SSH client configuration with modern crypto, connection multiplexing, and GPG agent integration.

## Contents

| File | Description |
| :--- | :--- |
| `config` | Global SSH client config — Mozilla OpenSSH Modern crypto, multiplexing, agent forwarding |
| `config.d/` | Per-host configuration fragments included by `config` (`Include config.d/*.conf`) |
| `authorized_keys` | Public keys authorized for inbound SSH to this host |
| `id_rsa_yubikey_*.pub` | Public keys for YubiKey-backed SSH authentication keys |
| `masters/` | ControlMaster socket directory for connection multiplexing |

## Notes

- Crypto settings follow the [Mozilla OpenSSH Modern](https://infosec.mozilla.org/guidelines/openssh) guidelines.
- Private keys are stored on YubiKeys; the GPG agent (`enable-ssh-support` in `~/.gnupg/gpg-agent.conf`) serves them via the SSH protocol.
- ControlMaster sockets persist for 4 hours to speed up subsequent connections to the same host.
- Drop per-host configuration into `config.d/*.conf` rather than editing `config` directly.
