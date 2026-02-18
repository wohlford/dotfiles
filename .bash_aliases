# Color support (from Debian /etc/skel/.bashrc, adapted for MacPorts)
if [[ -x /opt/local/bin/gdircolors ]]; then
  [[ -r ~/.dircolors ]] && \
    eval "$(/opt/local/bin/gdircolors -b ~/.dircolors)" \
    || eval "$(/opt/local/bin/gdircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='grep -F --color=auto'
  alias egrep='grep -E --color=auto'
fi

# Shell basics (ll, la, l from Debian /etc/skel/.bashrc)
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
command -v bbedit &>/dev/null && alias vi='bbedit'
alias less='/usr/bin/less -R'
alias beep="echo -en '\007'"
alias path='echo "$PATH" | tr : "\n"'

# Networking (flushdns from Apple Support HT202516)
alias ssh-add='/usr/bin/ssh-add'
alias ssh-killall='pkill -u "$USER" "^ssh$"'
alias ports='netstat -a -n | grep LISTEN'
alias flushdns='sudo killall -HUP mDNSResponder'

# Security (drduh/YubiKey-Guide, GnuPG Assuan protocol)
alias keychange='gpg-connect-agent "scd serialno" "learn --force" /bye && gpg --card-status'

# MacPorts
alias port-update='sudo port selfupdate && port outdated'
alias port-upgrade='sudo port upgrade -Rsup outdated'
alias port-install='sudo port install -Rsu'
alias port-rebuild='sudo port upgrade -sunp --force installed'
alias port-clean='sudo port -f clean --all all && sudo port -f uninstall inactive'

# Development tools
alias nodeinit='source /opt/local/share/nvm/init-nvm.sh'
alias updatenode='nodeinit && nvm install node'
alias update-claude='claude install'
alias update-gemini='nodeinit && npm install -g @google/gemini-cli@latest'
alias update-codex='nodeinit && npm install -g @openai/codex'
