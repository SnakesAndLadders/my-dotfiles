#!/usr/bin/env bash

# Shawn Ayotte - Cybera 2019
# This script is used to install Shawn Ayotte's environment. 

# Make sure we are running elevated
if [ "$EUID" -ne 0 ]
then echo "Please run as root (try 'sudo !!')"
  exit
fi

thisuser= who am i | awk '{print $1}'
echo $thisuser

# Copy dotfiles to proper location
cp -f home/.bashrc ~/
cp -f home/.bash_aliases ~/
cp -f home/.tmux.conf ~/
cp -f home/.vimrc ~/
cp -rf home/.tmux-themepack ~/
cp -rf home/.vim ~/

# Copy new MOTD and disable the ones we don't want 

cp -f home/update-motd.d/* /etc/update-motd.d/
rm /etc/motd || true
chmod -x /etc/update-motd.d/51-cloudguest || true
chmod -x /etc/update-motd.d/80-livepatch || true
chmod -x /etc/update-motd.d/10-help-text || true
chmod -x /etc/update-motd.d/50-motd-news || true

# Install all software that is needed

apt update
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

# Source new .bashrc
clear
source /home/${thisuser}/.bashrc

# Wrap up and tell user to use la 
printf "Installation complete. Please type 'la' to get started!\n--Shawn Ayotte\n"
