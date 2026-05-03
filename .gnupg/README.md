# .gnupg

GnuPG configuration for signing, encryption, and SSH authentication via GPG agent.

## Contents

| File | Description |
| :--- | :--- |
| `gpg.conf` | Default signing key, crypto preferences (AES256/SHA512), keyserver, display, privacy |
| `gpg-agent.conf` | SSH support, pinentry-mac, cache TTLs |
| `dirmngr.conf` | Keyserver (`hkps://keys.openpgp.org`) |

## Notes

- The default signing key is a YubiKey-backed OpenPGP key.
- `enable-ssh-support` lets the GPG agent serve as an SSH agent for YubiKey authentication keys.
- Crypto preferences follow the [riseup.net OpenPGP Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices).
- Pinentry path assumes [GPG Suite](https://gpgtools.org) (MacGPG2) is installed at `/usr/local/MacGPG2`.
