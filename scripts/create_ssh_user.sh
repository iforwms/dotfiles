#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ ! $1 ]]; then
    ppe "Please enter a username and optional group."
    ppi "usage: ./create_ssh_user.sh USER [GROUP]"
    exit 1
fi

ppi "Checking if user already exists."
if id "$1" &>/dev/null; then
    ppw "User $1 already exists, exiting."
    exit 1
fi

ppi "User does not exist, creating account."
sudo adduser --gecos "" $1

if [ $? -ne 0 ]; then
    ppe "Failed to create user."
    exit 1
fi

pps "User account for $1 created successfully!"

if [[ $2 ]]; then
    ppi "Found a group, adding $1 to $2 group."
    sudo usermod -a -G $2 $1
fi

ppi "Generating SSH keys for $1"
sudo mkdir -p /home/$1/.ssh
sudo ssh-keygen -q -N '' -t rsa -b 4096 -C '' -f /home/$1/.ssh/id_rsa

if [ $? -ne 0 ]; then
    ppe "Failed to create SSH keys."
    exit 1
fi

pps "SSH keys generated successfully."

ppi "Touching /home/$1/.ssh/authorized_keys"
sudo touch /home/$1/.ssh/authorized_keys

ppi "Copying public key to /home/$1/.ssh/authorized_keys"
cat /home/$1/.ssh/id_rsa.pub | sudo tee -a /home/$1/.ssh/authorized_keys >/dev/null

ppi "Fixing permissions."
sudo chmod 600 /home/$1/.ssh/authorized_keys
sudo chown -R $1:$1 /home/$1/

pps "Account and SSH keys generated successfully."

sudo tar -czf $HOME/ssh_keys_for_$1.tar.gz -C /home/$1/.ssh id_rsa id_rsa.pub

if [ $? -ne 0 ]; then
    ppe "Failed to generate SSH key tar file."
    exit 1
fi

ppi "SSH keys can be found here: $HOME/ssh_keys_for_$1.tar.gz"

exit 0
