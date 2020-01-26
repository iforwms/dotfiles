# Shortcuts
alias -- -='cd -'
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias _='sudo '
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadcli="source $HOME/.zshrc"
alias hosts="sudo vim /etc/hosts"
# alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
# alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -ahlF --color --group-directories-first"
alias ll="ls -lah"
weather() { curl -4 wttr.in/${1:-yangshuo} }
alias phpstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias subl='open -a "/Applications/Sublime Text.app" "`pwd`"'
alias c="clear"
alias ping='ping -c 5'  # Pings with 5 packets, not unlimited
alias df='df -h'        # Disk free, in gigabytes, not bytes
alias du='du -h -c'     # Calculate total disk usage for a folder
# alias zbundle="antibody bundle < $DOTFILES/zsh_plugins.txt > $DOTFILES/zsh_plugins.sh"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias code="cd $HOME/code"

# Laravel
alias a="php artisan"
alias ams="php artisan migrate:fresh --seed"
alias amm="php artisan make:model"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias pu="vendor/bin/phpunit"
alias pf="vendor/bin/phpunit --filter"

# Composer
alias c="composer"
alias cu="composer update"
alias cr="composer require"
alias ci="composer install"
alias cda="composer dump-autoload -o"
alias cchina="composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/"
alias cintl="composer config -g --unset repos.packagist"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && yarn install"

# IP addresses
alias ip="curl https://diagnostic.opendns.com/myip ; echo"
# alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Lilypond
alias scores="cd ~/Documents/scores"
alias lily="docker run --rm -v $(pwd):/app -w /app gpit2286/lilypond lilypond"
function lilyw() {
    find . -name "${1}.ly" | entr sh -c 'docker run --rm -v $(pwd):/app -w /app gpit2286/lilypond lilypond '"${1}.ly"' && open '"${1}.pdf";
}

# Vagrant
function hs() {
  (cd ~/Homestead && vagrant $*)
}
# alias v="vagrant global-status"
# alias vup="vagrant up"
# alias vhalt="vagrant halt"
# alias vssh="vagrant ssh"
# alias vreload="vagrant reload"
# alias vrebuild="vagrant destroy --force && vagrant up"

# Docker
# alias docker-composer="docker-compose"
# alias dstop="docker stop $(docker ps -a -q)"
# alias dpurgecontainers="dstop && docker rm $(docker ps -a -q)"
# alias dpurgeimages="docker rmi $(docker images -q)"
# dbuild() { docker build -t=$1 .; }
# dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Yarn
alias yr='yarn'
alias yra='yarn add'
alias yrs='yarn start'

# Django
alias pm="python manage.py"
alias pi="pip install"
alias p="python"
alias sv="source venv/bin/activate"

# Git
alias gl='git log --oneline --all --graph --decorate --pretty=format:"%Cgreen%h %Cred%d %Creset%s  %Cblue(%ar) <%an>" $*'
alias gs='git status'
alias gc='git commit -m'
alias gco='git checkout'
alias gca='git commit -am'
alias gcam='git commit --amend'
alias gps='git push'
alias gpl='git pull'
alias ga='git add'
alias nah='git reset --hard && git clean -df'
# alias apgi='git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached'

# SSH
alias ssht='ssh -D 8080 clients'
alias lproxy='networksetup -setsocksfirewallproxy "Wi-Fi" localhost 8080'
alias dproxy='networksetup -setsocksfirewallproxy "Wi-Fi" localhost 8080 && networksetup -setsocksfirewallproxy "Ethernet" localhost 8080'
alias lpxoff='networksetup -setsocksfirewallproxystate "Wi-Fi" off'
alias dpxoff='networksetup -setsocksfirewallproxystate "Wi-Fi" off && networksetup -setsocksfirewallproxystate "Ethernet" off'
alias lon='lproxy && ssht'
alias don='dproxy && ssht'

# Tmux
alias t="tmux"
alias ta="tmux a"
alias tls="tmux list-sessions"
alias tkl="tmux kill-session -t"

# Tmux session scripts
alias domino="$HOME/.dotfiles/tmux/domino.sh"
alias indier="$HOME/.dotfiles/tmux/indier.sh"
alias ide="$HOME/.dotfiles/tmux/ide.sh"

# Given a tmux session name, add suffixes until it is unique
function _tmux_get_unique_id() {
    local _id=$(tmux list-sessions|grep "^$1"|wc -l)
    local _unique=0
    while [[ $_unique != 1 ]]; do
        _id=$(($_id + 1))
        local clientid=$1-$_id
        tmux list-sessions | grep -q "^$clientid"
        _unique=$?
    done
    echo $clientid
}

# Attach to an existing tmux session.
#     A second argument can be given to select a particular window in the session.
#     eg    tma mysession 2  -> attach to window 2 in mysession
function tma() {
    local clientid=$(_tmux_get_unique_id $1)
    if [[ $# -eq 2 ]]; then
        tmux new-session -d -t $1 -s $clientid \; \
            set destroy-unattached on \; attach-session -t $clientid \; \
            select-window -t $2 \; refresh-client -t $clientid \;
    else
        tmux new-session -d -t $1 -s $clientid \; \
            set destroy-unattached on \; attach-session -t $clientid \; \
            refresh-client -t $clientid \;
    fi
}

# Create a new tmux session if needed, then attach to it.
function tm() {
    (tmux list-sessions|grep "^${1}" &>/dev/null) || \
        tmux new-session -d -s $1
    tma $1 $2
}

# Create a new window in the given tmux session and then attach to it.
function tmc() {
    local name=""
    if [[ $# -eq 2 ]]; then
        name="-n ${2}"
    fi
    local clientid=$(_tmux_get_unique_id $1)
    tmux new-session -d -t $1 -s $clientid \; \
        set destroy-unattached on \; new-window $name \; \
        attach-session -t $clientid \; \
        refresh-client -t $clientid \;
}
