#!/bin/bash

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


# OS
OS=`uname | tr A-Z a-z`

# Dotfile directory
DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); cd ..; pwd)


# Setting ssh-key
function keygen () {
  printf '\a'
  if [[ $ZSH_EVAL_CONTEXT = toplevel ]]; then
    read -q "yn?Do you set ssh-key for github? [y/N]: "
    printf "\n"
  else   
    read -n1 -p "Do you Set ssh-key for github? (y/N): " yn
    printf '\n'
  fi
  if [[ $yn = [yY] ]]; then
    mkdir -p $HOME/.ssh
    cd $HOME/.ssh
    ssh-keygen
    if [[ $ZSH_EVAL_CONTEXT = toplevel ]]; then
      read "SSH_KEY?Enter your ssh-key name for github. (Default: id_rsa): "
    else
      read -p "Enter your ssh-key name for github. (Default: id_rsa): " SSH_KEY
    fi
    cat $DIR/src/ssh/config | sed "s/ID_RSA/$SSH_KEY/" > $HOME/.ssh/config
  fi
}


# Install zsh and packages.
case $OS in
  "linux")
    DIST=`cat /etc/*release | tr A-Z a-z`
    if [[ $DIST =~ "centos" ]] || [[ $DIST =~ "fedora" ]] || [[ $DIST =~ "red hat" ]]; then
      echo "Red Hat key"
    elif [[ $DIST =~ "debian" ]] || [[ $DIST =~ "ubuntu" ]]; then
      echo $PSWD | sudo -S apt update && sudo apt upgrade -y
      . $DIR/scripts/install_zsh_debian.sh $PSWD
      . $DIR/scripts/install_fonts.sh $PSWD
      zsh $DIR/scripts/install_packages_debian.sh $PSWD $USER_NAME $USER_EMAIL
      keygen
      exit
    fi ;;
  "darwin")
    . $DIR/scripts/install_zsh_macos.sh $GO_VER ;;
esac
