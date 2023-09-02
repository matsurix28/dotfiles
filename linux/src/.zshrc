# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
HISTFILESIZE=10000
setopt appendhistory

# don`t duplicate zsh history.
setopt hist_ignore_dups

# Record start and end
setopt EXTENDED_HISTORY

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
  PS1="%F{2}%n%f:%F{4}%c%f$ "
else
  PS1='%n:%c$ '
fi
unset color_prompt

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# python pipenv create .venv in project directory.
export PIPENV_VENV_IN_PROJECT=true

# setting asdf.
. "$HOME/.asdf/asdf.sh"

# GO
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.go/bin"

# cargo
export PATH="$PATH:$HOME/.cargo/bin"

# basex
export PATH="$PATH:$HOME/basex/bin"

# fcitx
if (command -v fcitx > /dev/null) && [ $SHLVL = 1 ]; then
  export QT_IM_MODULE=fcitx
  export GTK_IM_MODULE=fcitx
  export XMODIFIERS=@im=fcitx
  export DefaultIMModule=fcitx
  fcitx-autostart > /dev/null 2>&1 &
fi

# Start docker
#sudo /etc/init.d/docker start
