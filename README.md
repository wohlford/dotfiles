# dotfiles

Personal dotfiles for macOS with MacPorts.

## Contents

| File | Description |
| :--- | :--- |
| `.bash_profile` | Login shell — PATH, environment variables, GPG agent |
| `.bashrc` | Interactive shell — history, prompt, completions |
| `.bash_aliases` | Shell aliases — MacPorts, networking, dev tools |
| `.inputrc` | Readline — tab completion, bracketed paste |
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

- [MacPorts](https://www.macports.org)
- [GPG Suite](https://gpgtools.org) (MacGPG2)

## License

[MIT](LICENSE)
