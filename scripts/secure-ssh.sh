#/bin/bash

echo "Current settings:"
grep 'PermitRootLogin\|PasswordAuthentication\|ChallengeResponseAuthentication\|UsePam' /etc/ssh/sshd_config|grep -v '#'

read -p "Do you want to update the sshd_config file? (y/n) " -n 1 -r

echo

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting..."
    exit 1
fi

echo "Disabling root login and password login"
sed '/^PermitRootLogin/s/yes/no/; /^PasswordAuthentication/s/yes/no/; /^ChallengeResponseAuthentication/s/yes/no/; /^UsePAM/s/yes/no/' /etc/ssh/sshd_config|sudo tee /etc/ssh/sshd_config

echo "Secured settings:"
grep 'PermitRootLogin\|PasswordAuthentication\|ChallengeResponseAuthentication\|UsePam' /etc/ssh/sshd_config|grep -v '#'
