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
  fi
else
  PSWD=$1
fi


# Dotfile directory
DOTDIR=$(cd $(dirname ${BASH_SOURCE:-$0}); cd ..; pwd)


# Update repositories.
echo $PSWD | sudo -S apt update && sudo apt upgrade -y


# Install zsh.
if (! command -v zsh > /dev/null); then
  echo "Zsh is not installed."
  echo "Install zsh."
  echo $PSWD | sudo -S apt install -y zsh
  echo "Change login shell to zsh."
  echo $PSWD | chsh -s /bin/zsh
else
  if [[ $SHELL =~ "/zsh"$ ]]; then
    echo "Current shell is zsh."
  else
    echo "Change login shell to zsh."
    echo $PSWD | chsh -s /bin/zsh
  fi
fi

# Make symbolic link
mv $HOME/.zshrc $HOME/.zshrc_bak
mv $HOME/.zsh_aliases $HOME/.zsh_aliases_bak
ln -s $DOTDIR/src/.zshrc $HOME/.zshrc
ln -s $DOTDIR/src/.dotfiles/.zsh_aliases $HOME/.zsh_aliases
