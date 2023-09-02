#!/usr/bin/env bash

if [ $# = 0 ]; then
  if [[ $ZSH_EVAL_CONTEXT = toplevel ]]; then
    read -s "PSWD?[sudo] password for $USER: "
    printf "\n"
    PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
    while [ -n "$PSWD_OK" ]; do
      echo "Sorry, try again."
      read -s "PSWD?[sudo] password for $USER: "
      printf '\n'
      PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
      PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
    done
    read "USER_NAME?Enter user name for git: "
    read "USER_EMAIL?Enter email address for git: "
  else 
    read -s -p "[sudo] password for $USER:" PSWD
    print "\n"
    PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
    while [ -n "$PSWD_OK" ]; do
      echo "Sorry, try again."
      read -s -p "[sudo] password for $USER: " PSWD
      printf '\n'
      PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
      PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
    done
    read -p "Enter user name for git: " USER_NAME
    read -p "Enter emai address for git: " USER_EMAIL
  fi
else
  PSWD=$1
  USER_NAME=$2
  USER_EMAIL=$3
fi

echo $PSWD | sudo -S apt update && sudo apt upgrade -y
echo $PSWD | sudo -S apt install -y git

git clone https://github.com/knterada5/.dotfiles.git $HOME/.dotfiles
source $HOME/.dotfiles/linux/scripts/start.sh $PSWD $USER_NAME $USER_EMAIL
