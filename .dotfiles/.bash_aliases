# Exemple d'alias

# Fichiers
alias ls='ls --color=auto' 
alias ll='ls -l' 
alias la='ls -lA' 
alias l='ls -CF' 
alias rm='rm -i'
alias mv='mv -i'
alias mkdir="mkdir -pv"
alias mdc='mkdir "$@" && cd "$@"'
alias cd='cd "$@" && ls'

# Recherche
alias grep='grep --color=auto' 
alias fgrep='fgrep --color=auto' 
alias egrep='egrep --color=auto' 
alias less='less -R'
alias h="history | grep"

# Ecran
alias cls="clear -x"    # Clear the terminal

# Installation
alias apu='sudo apt update'
alias apd='sudo apt upgrade -y'
alias maj='apu && apd'
alias api='sudo apt install -y'

# system
alias flushdns='sudo resolvectl flush-caches'
alias genpwd='date +%s | sha256sum | base64 | head -c$1'
alias data='cd /mnt/data'
alias h='history | grep' # Looking a string in History

# service

# vi
alias vi='vim'
alias vinet='sudo vi /etc/network/interfaces'

# Réseau
alias ipa= 'ip -c a' 
alias ping="ping -c 4"
alias ports='netstat -tulanp'
alias listen='sudo lsof -nP -iTCP -sTCP:LISTEN'
