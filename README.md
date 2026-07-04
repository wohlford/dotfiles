# dotfiles

Personal dotfiles for macOS with MacPorts.

## Contents

| File | Description |
| :--- | :--- |
| `.bash_profile` | Login shell — PATH, environment variables, GPG agent |
| `.bashrc` | Interactive shell — history, prompt, completions |
| `.bash_aliases` | Shell aliases — MacPorts, networking, dev tools |
| `.inputrc` | Readline — tab completion, bracketed paste |
| `.gitconfig` | Git — aliases, auto-signing (commits and tags), LFS |
| `.vimrc` | Vim configuration |

## Installation

```bash
git clone https://github.com/wohlford/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

## Private overrides

`.gitconfig` includes `~/.gitconfig.local` (gitignored, never committed) for
machine-local or private Git settings — a separate identity, alternate signing
key, or per-directory `includeIf` rules. Git ignores the include silently when
the file is absent. See [`.gitconfig.local.example`](.gitconfig.local.example)
for the pattern.

## Dependencies

- [MacPorts](https://www.macports.org)

## License

[MIT](LICENSE)
