#!/bin/zsh

if [ $# = 0 ]; then
  if [[ $ZSH_EVAL_CONTEXT = toplevel ]]; then
    read -s "PSWD?[sudo] password for $USER: "
    printf "\n"
    PSWD_OK="$(echo $PSWD | sudo -S echo ok 2>&1 > /dev/null)"
　　while [ -n "$PSWD_OK" ]; do
      echo "Sorry, try again."
      read -s "PSWD2?[sudo] $USER: "
      printf '\n'
      PSWD_OK="$(echo $PSWD2 | sudo -S echo ok 2>&1 > /dev/null)"
      PSWD_OK="$(echo $PSWD2 | sudo -S echo ok 2>&1 > /dev/null)"
    done
    read "USER_NAME?Enter user name for git: "
    read "USER_EMAIL?Enter email address for git: "
  else 
    read -s -p "[sudo] password for $USER:" PSWD
    print "\n"
    while [ -n "$PSWD_OK" ]; do
  　　echo "Sorry, try again."
  　　read -s -p "[sudo] $USER: " PSWD2
  　　printf '\n'
  　　PSWD_OK="$(echo $PSWD2 | sudo -S echo ok 2>&1 > /dev/null)"
  　　PSWD_OK="$(echo $PSWD2 | sudo -S echo ok 2>&1 > /dev/null)"
　　done
    read -p "Enter user name for git: " USER_NAME
    read -p "Enter emai address for git: " USER_EMAIL
  fi
else
  PSWD=$1
  USER_NAME=$2
  USER_EMAIL=$3
fi

# dotfiles directory.
DOTDIR=$(cd $(dirname ${BASH_SOURCE:-$0}); cd ..; pwd)

# Make symbolic link
mv $HOME/.zshrc $HOME/.zshrc_bak
mv $HOME/.zsh_aliases $HOME/.zsh_aliases_bak
ln -s $DOTDIR/src/.zshrc $HOME/.zshrc
ln -s $DOTDIR/src/.zsh_aliases $HOME/.zsh_aliases
. $HOME/.zshrc


# Update repositories.
echo $PSWD | sudo -S apt update && sudo apt upgrade -y

# Install required packages.
while read line; do
  if [[ ! $line =~ "#" ]] && [[ ! -z $line ]]; then
    echo $PSDW | sudo -S apt install -y $line
  fi
done < $DOTDIR/data/packages

# Set git config.
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

# Install asdf.
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.11.3
. $HOME/.zshrc

# Install Laguages.
. $DOTDIR/scripts/install_languages.sh

# Clone and install neovim.
git clone https://github.com/neovim/neovim $HOME/neovim
cd $HOME/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
git checkout stable
echo $PSWD | sudo -S make install
cd $HOME

# Install NvChad
git clone https://github.com/NvChad/NvChad $HOME/.config/nvim --depth 1 && nvim --headless +q
rm -rf $HOME/.config/nvim/lua/custom
ln -s $DOTDIR/src/custom $HOME/.config/nvim/lua/custom
nvim --headless +q
cd $HOME

# Install LSP via Mason
nvim --headless +"MasonInstallAll" +q

# Install lazygit via go.
go install github.com/jesseduffield/lazygit@latest
asdf reshim golang

# Install dust
cargo install du-dust

# Remove install file.
echo $PSWD | sudo -S rm -r $HOME/neovim

# List of packages version.
. $DOTDIR/scripts/log.sh >> $HOME/installed_versions.log
