# MacPorts (guide.macports.org, Section 2.5)
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH=/opt/local/share/man:$MANPATH
export DISPLAY=:0

# Python
export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"

# GNU coreutils
export PATH="/opt/local/libexec/gnubin:$PATH"

# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# Editor
export VISUAL=vim
export EDITOR=vim
export MP_EDITOR=vim
if [[ -x /Applications/BBEdit.app/Contents/Helpers/bbedit_tool ]]; then
  export EDITOR=/Applications/BBEdit.app/Contents/Helpers/bbedit_tool
  export MP_EDITOR=/Applications/BBEdit.app/Contents/Helpers/bbedit_tool
fi

# Colors (FreeBSD ls(1), Linux-style bold variant)
export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"

# Vagrant (developer.hashicorp.com/vagrant)
export VAGRANT_PREFERRED_PROVIDERS="vmware_desktop,virtualbox"
export VAGRANT_DEFAULT_PROVIDER=vmware_desktop

# gpgtools.org
if [[ -d "/usr/local/MacGPG2/bin" ]]; then
  export PATH="/usr/local/MacGPG2/bin:$PATH"

  # gpg-agent for ssh
  export GPG_TTY="$(tty)"
  export SSH_AUTH_SOCK=$(/usr/local/MacGPG2/bin/gpgconf --list-dirs agent-ssh-socket)
  /usr/local/MacGPG2/bin/gpgconf --launch gpg-agent
fi

# Apple — suppress macOS Catalina+ zsh default shell warning
export BASH_SILENCE_DEPRECATION_WARNING=1

[[ -f ~/.bashrc ]] && source ~/.bashrc
