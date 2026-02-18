# Based on Debian/Ubuntu /etc/skel/.bashrc

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# Shell options
shopt -s histappend
shopt -s checkwinsize

# History
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT='%F %T  '

# Prompt
if [[ -x /opt/local/bin/tput ]] && tput setaf 1 >&/dev/null; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi

# Set xterm title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
esac

# Aliases
if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

# Completions
if [[ -f /opt/local/etc/profile.d/bash_completion.sh ]]; then
  . /opt/local/etc/profile.d/bash_completion.sh
fi

# Tool integrations
[[ -x /opt/local/bin/lesspipe.sh ]] && eval "$(SHELL=/bin/sh /opt/local/bin/lesspipe.sh)"
