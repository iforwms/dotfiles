# sudo apt-get install -y php7.4-{bcmath,curl,bz2,intl,xml,gd,mbstring,mysql,zip}

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
# alias _='sudo '
alias reloadcli="source $HOME/.zshrc"
alias hosts="sudo vim /etc/hosts"
alias bi="brew install"
alias killPhotoA="launchctl disable user/$(id -u)/com.apple.photoanalysisd"
# alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
# alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -ahlF --color --group-directories-first"
# weather() { curl -4 "wttr.in/${1:-yangshuo}" }
# alias phpstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias subl='open -a "/Applications/Sublime Text.app" "$(pwd)"'
alias mscore='/Applications/MuseScore\ 4.app/Contents/MacOS/mscore'
alias c="clear"
# alias ping='ping -c 5'  # Pings with 5 packets, not unlimited
# alias df='df -h'        # Disk free, in gigabytes, not bytes
# alias du='du -h -c'     # Calculate total disk usage for a folder
# alias zbundle="antibody bundle < $DOTFILES/zsh_plugins.txt > $DOTFILES/zsh_plugins"
alias vimgolf='docker run --rm -it -e "key=4ff4186b1f258b4dd2755c104835abeb" kramos/vimgolf'
alias deploy='sudo -u www-data ./deploy'

if command -v eza &> /dev/null; then
  eza_params=(
    '--git' '--icons' '--group' '--group-directories-first'
    '--time-style=long-iso' '--color-scale=all' '--hyperlink'
    '--git-ignore'
  )
  alias ls="eza -F --group --header ${eza_params}"
  alias la='ls --all'
  alias l='ls --long'
else
  alias l='ls -vlAh --color=auto --time-style="+%Y %b %d %H:%M"'
  alias ls='ls -vA --color=auto --time-style="+%Y %b %d %H:%M"'
fi


# Apt
alias iap='sudo apt install'
alias uap='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

if command -v ggrep &> /dev/null; then
  alias grep='ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
fi

alias randpw="$DOTFILES/scripts/random-password"

# Git commit short cuts
alias gcobs="$DOTFILES/scripts/git-commit ~/obsidian"
alias gcdot="$DOTFILES/scripts/git-commit ~/.dotfiles"

alias npmzh="npm config set registry https://registry.npm.taobao.org/"
alias npmus="npm config set registry https://registry.npmjs.org/"

# Docker
alias doc="docker-compose"
# alias dstop="docker stop $(docker ps -a -q)"
# alias dpurgec="dstop && docker rm $(docker ps -a -q)"
# alias dpurgei="docker rmi $(docker images -q)"
# dbuild() { docker build -t=$1 .; }
# dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Spoof timezone
# America/Anchorage
# function spoofTz

# Directories
alias dot="cd $DOTFILES"
alias library="cd $HOME/Library"
function code() {
  if [[ -d $HOME/code ]]; then
    cd "$HOME/code"
  else
    cd /var/www
  fi
}
alias ssd="$DOTFILES/scripts/shutdown"
alias ind="cd $HOME/code/indier"
alias dom="cd $HOME/code/domino"
alias exp="cd $HOME/code/expednet"
alias obs="cd $HOME/obsidian"
alias kim="cd $HOME/code/kim"
alias dl="cd $HOME/downloads 2>/dev/null || cd $HOME/storage/downloads"
alias docs="cd $HOME/Documents"

alias le="python3 $DOTFILES/scripts/logic-stem-export.py"

alias knot=$DOTFILES/scripts/animated-knots

alias dnsReset="sudo killall -HUP mDNSResponder"
alias a="php artisan"
alias aw="sudo -u www-data php artisan"
alias ams="php artisan migrate:fresh --seed"
alias amm="php artisan make:model"

# PHP
alias php72="/usr/local/Cellar/php@7.2/7.2.34_1/bin/php"
alias php73="/usr/local/Cellar/php@7.3/7.3.25_1/bin/php"
alias php74="/usr/local/Cellar/php@7.4/7.4.13_1/bin/php"
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias pu="vendor/bin/phpunit"
alias pf="vendor/bin/phpunit --filter"

# Composer
# alias cu="composer update"
alias cr="composer require"
alias ci="composer install"
alias cda="composer dump-autoload -o"
alias cchina="composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/"
alias cintl="composer config -g --unset repos.packagist"

# Yarn
alias ychina="yarn config set registry https://registry.yarnpkg.com"
alias yintl="yarn config set registry https://registry.npm.taobao.org"

# Cargo
alias cab="cargo build"
alias cabr="cargo build --release"
alias car="cargo run"
alias cac="cargo check"

# Android
alias apk="./gradlew assembleDebug && scp ./app/build/outputs/apk/debug/app-debug.apk clients:~/code/iforwms/public/music"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && yarn install"

# gdb
alias gdbinit="echo 'set disassembly-flavor intel' > $HOME/.gdbinit"

# less
alias less="less -N"

alias acl="arduino-cli"

# IP addresses
alias myip="curl https://diagnostic.opendns.com/myip ; echo"
alias mylip="ifconfig tun0 | awk '/inet / {print \$2}'"
# alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Lilypond
# alias lilypond="/Applications/LilyPond.app/Contents/Resources/bin/lilypond"
# alias lilypond-book="/Applications/LilyPond.app/Contents/Resources/bin/lilypond-book"
alias scores="cd ~/Documents/scores"
alias lily="docker run --rm -v $(pwd):/app -w /app gpit2286/lilypond lilypond"
function lilyw() {
    find . -name "*.ly" | entr sh -c 'docker run --rm -v $(pwd):/app -w /app gpit2286/lilypond lilypond '"${1}.ly"' && open '"${1}.pdf";
}

# Vagrant
function hs() {
  (cd ~/Homestead && vagrant "$@")
}
# alias v="vagrant global-status"
# alias vup="vagrant up"
# alias vhalt="vagrant halt"
# alias vssh="vagrant ssh"
# alias vreload="vagrant reload"
# alias vrebuild="vagrant destroy --force && vagrant up"

# Yarn
alias yr='yarn'
alias yra='yarn add'
alias yrs='yarn start'

# Django
# alias pm="python manage.py"
# alias pi="pip install"
# alias p="python"
# alias sv="source venv/bin/activate"

alias inv="${DOTFILES}/scripts/inventory-lookup"
alias dict="${DOTFILES}/scripts/dictionary-lookup"

# Git
alias gau='echo - "a\n*\nq\n" | git add -i > /dev/null'
# alias gl='git log --oneline --all --graph --decorate --pretty=format:"%Cgreen%h %Cred%d %Creset%s  %Cblue(%ar) <%an>" $*'
alias gl="git log --oneline --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glb="git log --simplify-by-decoration --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
# alias glb='git log --graph --simplify-by-decoration --pretty=format:'%d' --all'
alias gs='git status'
alias gc='git commit -m'
alias gcl="${DOTFILES}/scripts/git-clone"
alias gad='git add $(git diff --name-only --cached)'
alias gco='git checkout'
alias gca='git commit -am'
alias gcam='git commit --amend'
alias gps='git push'
alias gpd='git push && ./deploy-remote'
alias gpl='git pull'
alias ga='git add'
alias gaa='git add .'
alias gd='git diff'
alias gds='git diff --staged'
alias grs='git restore --staged'
alias nah='git reset --hard && git clean -df'
function gq() {
  git add .
  git commit -m "Quick commit - $(date '+%Y/%m/%d %H:%M')"
  git push
  ./deploy-remote $1
}

# alias apgi='git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached'
# find ~/code -mindepth 1 -maxdepth 4 -type d -name .git -execdir git status -s \;
function ggs() {
    $HOME/.dotfiles/scripts/globalGitStatus $HOME/.dotfiles
    $HOME/.dotfiles/scripts/globalGitStatus $HOME/obsidian

    $HOME/.dotfiles/scripts/globalGitStatus $HOME/code/expednet/moodle/mod/aliyun
    $HOME/.dotfiles/scripts/globalGitStatus $HOME/code/expednet/moodle/payment/gateway/alipay
    $HOME/.dotfiles/scripts/globalGitStatus $HOME/code/expednet/moodle/payment/gateway/blueocean
    $HOME/.dotfiles/scripts/globalGitStatus $HOME/code/expednet/moodle/payment/gateway/wechat

    $HOME/darts-hub/darts-caller

    find -L $HOME/code -mindepth 1 -maxdepth 4 -type d -name .git -prune -exec $HOME/.dotfiles/scripts/globalGitStatus {} \;

    pass git status
}

function ggp() {
    pass git push
    pass git pull

    $HOME/.dotfiles/scripts/globalGitPull $HOME/.dotfiles
    $HOME/.dotfiles/scripts/globalGitPull $HOME/obsidian

    $HOME/.dotfiles/scripts/globalGitPull $HOME/code/expednet/moodle/mod/aliyun
    $HOME/.dotfiles/scripts/globalGitPull $HOME/code/expednet/moodle/payment/gateway/alipay
    $HOME/.dotfiles/scripts/globalGitPull $HOME/code/expednet/moodle/payment/gateway/blueocean
    $HOME/.dotfiles/scripts/globalGitPull $HOME/code/expednet/moodle/payment/gateway/wechat

    $HOME/darts-hub/darts-caller

    find -L $HOME/code -mindepth 1 -maxdepth 4 -type d -name .git -prune -exec $HOME/.dotfiles/scripts/globalGitPull {} \;
     # | sed s/.git// | xargs -I % git -C % pull
}

function gitPurge() {
  git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch $1" \
  --prune-empty --tag-name-filter cat -- --all
  # echo $1 >> .gitignore
  # git add .gitignore
  # git commit -m "Add sensitive file to .gitignore"
  # git push origin --force --all
  #
  # If tags have been published
  # git push origin --force --tags
  #
  # If git filter-branch had no unintended side effects
  # git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
  # git reflog expire --expire=now --all
  # git gc --prune=now
}

# Create remote github repo
function gri() {
    curl -u 'iforwms' https://api.github.com/user/repos -d '{"name":"$1", "private": "true", "key": "$(cat ~/.ssh/id_rsa.pub)"}'
    git init
    git remote add origin git@github.com:iforwms/$1.git
    # curl \
    #     -X POST \
    #     -H "Accept: application/vnd.github.v3+json" \
    #     https://api.github.com/user/repos \
    #     -d '{"name":"$1", "private": true, "key": "$(cat ~/.ssh/id_rsa.pub)"}'
}

# Compile asm > o > program
function asm() {
    nasm -f elf32 $1.asm -o $1.o
    ld -m elf_i386 $1.o -o $1
}
function asmr() {
    nasm -f elf32 $1.asm -o $1.o
    ld -m elf_i386 $1.o -o $1
    ./$1
    echo $?
}

# beets
function beet() {
    docker exec -t beets /bin/bash -c "beet $1"
}
alias beetimport="docker exec -u abc -it beets /bin/bash -c 'beet import /downloads'"
alias beetupdate="docker exec -it beets /bin/bash -c 'beet update'"
# If you make any configuration changes that would alter the
# physical file structure of your collection, you will need to
# run a fresh import on the clean music folder:
# docker exec -it beets /bin/bash -c 'beet import /music'

# rsync
alias scpr="rsync -avz --progress"
alias sl="$HOME/.dotfiles/scripts/sync /Users/ifor/Logic/ /Volumes/IFOR2T/Music/Logic/"
alias sm="$HOME/.dotfiles/scripts/sync /Users/ifor/Music/ /Volumes/IFOR2T/Music/"

# SSH
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
# alias addssh='ssh $1 "echo \"`cat ~/.ssh/id_rsa.pub`\" >> ~/.ssh/authorized_keys"'
# Make sure our custom terminal with italics is not used no remote machines.
alias ssh="TERM=xterm-256color ssh"
alias ssht='ssh -D 2080 clients'
alias lproxy='networksetup -setsocksfirewallproxy "Wi-Fi" localhost 2080'
alias dproxy='networksetup -setsocksfirewallproxy "Wi-Fi" localhost 2080 && networksetup -setsocksfirewallproxy "Ethernet" localhost 2080'
alias loff='networksetup -setsocksfirewallproxystate "Wi-Fi" off'
alias doff='networksetup -setsocksfirewallproxystate "Wi-Fi" off && networksetup -setsocksfirewallproxystate "Ethernet" off'
alias lon='lproxy && ssht'
alias don='dproxy && ssht'
alias pc='proxychains4'

alias nse='cd /etc/nginx/sites-enabled'
alias nsa='cd /etc/nginx/sites-available'

# Tmux
alias t="tmux"
alias ta="tmux a||tmux"
alias tat="tmux a -t"
alias tls="tmux list-sessions"
alias tkl="tmux kill-session -t"
alias tcs=$DOTFILES/scripts/tmux-sessions

alias cmi=$DOTFILES/scripts/cmus-init

# Create PDF from markdown
alias md2pdf=$DOTFILES/scripts/markdown2pdf

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
