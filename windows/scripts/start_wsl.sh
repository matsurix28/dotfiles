#!/bin/bash

printf '\a'
read -s -p "[sudo] password for $USER:" PSWD
printf "\n"
read -p "Enter user name for git: " USER_NAME
read -p "Enter email address for git: " USER_EMAIL

# Auto generate resolv.conf false
echo $PSWD | sudo -S sh -c "echo '[network]\ngenerateResolvConf = false' > /etc/wsl.conf" > /dev/null 2>&1

# Check DNS server
if (! ping -c 2 google.com > /dev/null 2>&1); then
  sudo rm /etc/resolv.conf
  sudo -S sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf" > /dev/null 2>&1
  if (! ping -c 2 google.com > /dev/null 2>&1); then
    for I; do
      sudo -S sh -c "echo 'nameserver $I' > /etc/resolv.conf" > /dev/null 2>&1
      if (ping -c 2 google.com > /dev/null 2>&1); then
        break
      fi
    done
  fi
fi

curl -LO https://raw.githubusercontent.com/knterada5/.dotfiles/main/install_linux.sh; source install_linux.sh $PSWD $USER_NAME $USER_EMAIL
exit
