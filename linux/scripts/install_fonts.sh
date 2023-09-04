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
    printf "\n"
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


echo $PSWD | sudo -S apt install -y language-selector-common
echo $PSWD | sudo -S apt install -y $(check-language-support -l ja)
echo $PSWD | sudo -S apt install -y fcitx-mozc
echo $PSWD | sudo -S apt install -y fonts-noto-color-emoji
echo $PSWD | sudo -S apt install -y fonts-symbola
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/nerd-fonts
cd $HOME
./nerd-fonts/install.sh SourceCodePro
im-config -n fcitx
fcitx > /dev/null 2>&1 &
sleep 5
rm -rf $HOME/.config/fcitx
ln -s $DOTDIR/src/fcitx $HOME/.config/fcitx

