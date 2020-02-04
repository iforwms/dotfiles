#!/bin/bash

if [ -z $1 ] || (( $1 < 1 )) || (( $1 > 4 ))
then
    echo "Please choose an installation type:"
    echo "1: Server"
    echo "2: iMac"
    echo "3: MacBook"
    echo "4: Termux"
    echo ""
    echo "Usage: ./install.sh [type]"
    exit
fi


echo "Creating a Code directory"
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/code 2> /dev/null

if (( $1 == 1 ))
then
    sudo -v

    echo "Setting up server..."

    echo "Updating repositories"
    sudo apt update

    echo "Upgrading packages"
    sudo apt upgrade -y

    # TODO
    # Install Yarn, Node, Composer, tmux

    echo "Installing ZSH"
    sudo apt install -y zsh

    # add zsh at default shell
elif (( $1 < 4 ))
then
    sudo -v

    echo "Setting up your Mac..."

    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Updating Homebrew recipes"
    brew update

    echo "Installing all brew dependencies (See Brewfile)"
    brew tap homebrew/bundle
    brew bundle

    echo "Installing PHP extensions with PECL"
    pecl install memcached imagick

    echo "Installing global Composer packages"
    /usr/local/bin/composer global require laravel/installer

    # Install Laravel Valet
    # $HOME/.composer/vendor/bin/valet install
else
    echo "Updating packages"
    pkg upgrade
    echo "installing, tree, tmux, zsh, openssh, php, python, git, vim, node"
    pkg install tree tmux openssh zsh php python vim git

    echo "Setting zsh as default shell"
    chsh -s zsh
fi

echo "Setting up ZSH"
rm -rf $HOME/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

echo "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Creating ZSH custom plugins directory"
mkdir -p $HOME/.dotfiles/plugins

echo "Downloading ZSH plugins"
rm -rf $HOME/.dotfiles/plugins/zsh-syntax-highlighting
rm -rf $HOME/.dotfiles/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/plugins/zsh-autosuggestions

echo "Setting up Vim"
rm -rf $HOME/.vim
ln -s $HOME/.dotfiles/.vim $HOME/.vim

echo "Installing php vim syntax highlighting"
curl -fsSL -o $HOME/.dotfiles/.vim/syntax/php.vim https://raw.githubusercontent.com/StanAngeloff/php.vim/master/syntax/php.vim

echo "Installing vim color scheme"
curl -fsSL -o $HOME/.dotfiles/.vim/colors/onedark.vim https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim
curl -fsSL -o $HOME/.dotfiles/.vim/autoload/onedark.vim https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim

echo "Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

echo "Install tmux navigator vim plugin"
curl -fsSL -o $HOME/.dotfiles/.vim/plugin/tmux_navigator.vim https://raw.githubusercontent.com/christoomey/vim-tmux-navigator/master/plugin/tmux_navigator.vim

echo "Install vim surround plugin"
curl -fsSL -o $HOME/.dotfiles/.vim/plugin/surround.vim https://raw.githubusercontent.com/tpope/vim-surround/master/plugin/surround.vim

echo "Install vim commentary plugin"
curl -fsSL -o $HOME/.dotfiles/.vim/plugin/commentary.vim https://raw.githubusercontent.com/tpope/vim-commentary/master/plugin/commentary.vim

echo "Creating symlink for .tmux.conf"
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

if (( $1 > 1 && $install_type < 4 )); then
echo "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

    echo "Symlink Mackup config file to the home directory"
    rm -rf $HOME/.mackup.cfg
    ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

    echo "Symlink .gitconfig file to the home directory"
    rm -rf $HOME/.gitconfig
    ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

    echo "Setting up lilypond"
    ln -s $HOME/.dotfiles/lilypond/lilypond-link /usr/local/bin/lilypond-link
    chmod +x /usr/local/bin/lilypond-link

    echo "Cloning lilypond vim syntax highlighting"
    git clone git@github.com:matze/vim-lilypond.git $HOME/.dotfiles/lilypond/vim

    echo "Installing tmux cmus plugin"
    git clone https://github.com/Mpdreamz/tmux-cmus $HOME/.dotfiles/tmux/tmux-cmus

    # TODO: Install cmus playlists

    echo "Seting up terminfo config"
    echo "## remember to update iterm (Preferences > Profiles > Terminal > Report Terminal Type: > xterm-256color-italic)"
    tic $HOME/.dotfiles/tmux/256-italic-terminfo
    tic -x $HOME/.dotfiles/tmux/tmux-terminfo

    # Install python?
    # echo "Installing beets"
    # pip3 install beets
    # echo "Setting up beets"
    # mkdir -p $HOME/.config/beets
    # rm -rf $HOME/.config/beets/config.yaml
    # ln -s $HOME/.dotfiles/beets/config.yaml $HOME/.config/beets/config.yaml

    echo "Updating macOS preferences"
    # We will run this last because this will reload the shell
    source .macos
fi
