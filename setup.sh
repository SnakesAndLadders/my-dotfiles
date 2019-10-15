#!/usr/bin/env bash

# Shawn Ayotte - Cybera 2019
# This script is used to install Shawn Ayotte's environment. 

# Make sure we are running elevated
if [ "$EUID" -ne 0 ]
then echo "Please run as root (try 'sudo !!')"
  exit
fi

set -o errexit # script will exit if a command fails. append any command with "|| true" to ignore errors on that line 
set -o nounset # to exit when your script tries to use undeclared variables.
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

# Copy dotfiles to proper location
cp home/.bashrc ~/
cp home/.bash_aliases ~/
cp home/.tmux.conf ~/
cp home/.vimrc ~/
cp -r home/.tmux-themepack ~/
cp -r home/.vim ~/

# Copy new MOTD and disable the ones we don't want 

cp home/update-motd.d/* /etc/update-motd.d/
rm /etc/motd || true
chmod -x /etc/update-motd.d/51-cloudguest || true
chmod -x /etc/update-motd.d/80-livepatch || true
chmod -x /etc/update-motd.d/10-help-text || true
chmod -x /etc/update-motd.d/50-motd-news || true

# Install all software that is needed

function installall {
  aptcheck=(lm-sensors unrar unzip cabextract curl netstat pydf mc w3m landscape-common figlet)
  toinstall=""
  for i in ${aptcheck[@]}
  do
    echo "${i}"
    package="$(which ${i})"
    if [ -z "$package" ] ; then
      toinstall="$toinstall $i"
    fi
  done
  echo " installing ${toinstall}"
  if [ -z "$toinstall" ] ; then
    echo "everything is installed"
  else
    sudo apt install ${toinstall} -y
  fi
}

# Source new .bashrc
clear
source ~/.bashrc

# Wrap up and tell user to use la 
echo "Installation complete. Please type 'la' to get started!\n--Shawn Ayotte\n"
