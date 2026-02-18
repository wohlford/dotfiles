# dotfiles

Personal dotfiles for macOS with MacPorts.

## Contents

| File | Description |
| :--- | :--- |
| `.gitconfig` | Git — aliases, signing, LFS |
| `.gnupg/gpg.conf` | GnuPG — key preferences, crypto settings |
| `.gnupg/gpg-agent.conf` | GPG agent — SSH support, pinentry |
| `.gnupg/dirmngr.conf` | Keyserver configuration |

## Installation

```bash
git clone https://github.com/wohlford/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

## Dependencies

- [GPG Suite](https://gpgtools.org) (MacGPG2)

## License

[MIT](LICENSE)
