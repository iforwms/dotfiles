#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ ! $1 ]]; then
    ppe "Please enter a username and optional group."
    ppi "usage: ./create_ssh_user.sh USER [GROUP]"
    exit 1
fi

echo
echo -n "Enter a password for $1: "
read -s PASS
echo
echo
read -s -p "Confirm password: " PASS_CONFIRM
echo
if [ $PASS != $PASS_CONFIRM ]; then
    ppe "Passwords do not match."
    exit 1
fi

ppi "Passwords match - checking if user already exists."
if id "$1" &>/dev/null; then
    ppw "User $1 already exists, exiting."
    exit 1
fi

ppi "User does not exist, creating account."
sudo adduser --disabled-password --gecos "" $1

if [ $? -ne 0 ]; then
    ppe "Failed to create user."
    exit 1
fi

ppi "Setting user password."
sudo usermod -p $(echo $PASS|mkpasswd -m sha-512 -s) $1

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

CREDENTIALS=/tmp/CREDENTIALS
ZIP=$HOME/$(uname -n)_login_for_$1.tar.gz

URLS=$(grep -hRi server_name /etc/nginx/sites-enabled 2>/dev/null|sed -E 's/[[:space:]]+server_name //;s/;//;s/^\.//'|sort -u|tr '\n' ' ')

if [[ $URLS ]]; then
    ppi "Finding IP addresses for the following URLs:\n\n      - $(echo $URLS|sed 's/ /\n      - /g')"

    ppi "Found the following server IP addresses:"
    dig +short $URLS|sort|uniq -c|sort -nr|awk '{print "      ",$2}'
fi

echo
read -p "Please enter server IP address: " IP

exit

echo "SSH login: $1@$IP" >> $CREDENTIALS
echo "Account password: $PASS" >> $CREDENTIALS

sudo tar -czf $ZIP -C /home/$1/.ssh id_rsa id_rsa.pub -C /tmp CREDENTIALS

if [ $? -ne 0 ]; then
    ppe "Failed to generate SSH key tar file."
    exit 1
fi

rm -f $CREDENTIALS

ppi "SSH keys can be found here: $ZIP"

exit 0
