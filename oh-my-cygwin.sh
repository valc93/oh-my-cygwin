#!/bin/bash
set -e

SIMPLE_BACKUP_SUFFIX=".orig"
APT_CYG="$(mktemp /tmp/apt-cyg.XXXXXXXX)"

# install apt-cyg
wget --no-check-certificate "rawgit.com/transcode-open/apt-cyg/master/apt-cyg" -O "${APT_CYG}"
if [ $(uname -m) == 'i686' ]; then arch="x86"; else arch="x86_64"; fi; sed -i "s/\(wget -N \$mirror\)\(\/setup\..*\)/\1\/$arch\2/" /usr/local/bin/apt-cyg
chmod +x "${APT_CYG}"

# install some stuff like vim and git
"${APT_CYG}" install zsh mintty vim curl git openssh ftp make tar


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

# install apt-cyg
install --backup "${APT_CYG}" /usr/local/bin/apt-cyg

# setting up zsh as default
sed -i "s/$USER\:\/bin\/bash/$USER\:\/bin\/zsh/g" /etc/passwd

# et voila just start it
/usr/bin/env zsh
