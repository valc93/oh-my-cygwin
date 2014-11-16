#!/bin/bash
set -e

SIMPLE_BACKUP_SUFFIX=".orig"

# install apt-cyg
wget --no-check-certificate "rawgit.com/transcode-open/apt-cyg/master/apt-cyg"
chmod +x apt-cyg
mv apt-cyg /usr/local/bin/

# install some stuff like vim and git
apt-cyg install zsh mintty vim curl git openssh

# install OH MY ZSH
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh; if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then cp ~/.zshrc ~/.zshrc.orig; rm ~/.zshrc; fi 


# Create initial /etc/zshenv
[[ ! -e /etc/zshenv ]] && echo export PATH=/usr/bin:\$PATH > /etc/zshenv

install --backup ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#setting up vim
VIMRC_EXAMPLE=`find /usr/share/vim -type f -name vimrc_example.vim | head -n 1`
if [ ! -f ~/.vimrc ] && [ -n "${VIMRC_EXAMPLE}" ]
then
  install "${VIMRC_EXAMPLE}" ~/.vimrc
fi

# setting up zsh as default
sed -i "s/$USER\:\/bin\/bash/$USER\:\/bin\/zsh/g" /etc/passwd

# et voila just start it
/usr/bin/env zsh
