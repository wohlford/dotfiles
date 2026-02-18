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
| `.ssh/config` | SSH — crypto, multiplexing, GPG agent |
| `.tmux.conf.local` | tmux customization (uses gpakosz/.tmux) |
| `.vimrc` | Vim configuration |

## Installation

```bash
git clone --recursive https://github.com/wohlford/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

## Dependencies

- [MacPorts](https://www.macports.org)
- [GPG Suite](https://gpgtools.org) (MacGPG2)
- [gpakosz/.tmux](https://github.com/gpakosz/.tmux) (included as submodule)

## License

[MIT](LICENSE)
