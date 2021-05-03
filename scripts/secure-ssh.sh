#!/bin/bash

echo "Current settings:"
grep -n 'PermitRootLogin\|PasswordAuthentication\|ChallengeResponseAuthentication\|UsePam' /etc/ssh/sshd_config|grep -v '#'
echo

read -p "Do you want to update the sshd_config file? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
   echo
   echo "Aborting..."
   exit 1
fi

echo
echo "Disabling root login and password login"
sed '/^PermitRootLogin/s/yes/no/; /^PasswordAuthentication/s/yes/no/; /^ChallengeResponseAuthentication/s/yes/no/; /^UsePAM/s/yes/no/        ' /etc/ssh/sshd_config|sudo tee /etc/ssh/sshd_config >/dev/null

echo
echo "Secured settings:"
grep -n 'PermitRootLogin\|PasswordAuthentication\|ChallengeResponseAuthentication\|UsePam' /etc/ssh/sshd_config|grep -v '#'

read -p "Settings updated, you need to restart the ssh service for these changes to take effect, restart now? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
   echo
   echo "Service not restarted."
   exit 1
else
   echo
   echo "Restarting ssh service"
   sudo service ssh restart
   echo "Service restarted."
   exit 0
fi

