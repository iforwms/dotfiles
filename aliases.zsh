# Shortcuts
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
alias zbundle="antibody bundle < $DOTFILES/zsh_plugins.txt > $DOTFILES/zsh_plugins.sh"

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

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && yarn install"

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
