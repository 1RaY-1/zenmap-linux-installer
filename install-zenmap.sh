#!/usr/bin/env bash

# Simple bash script to install zenmap on Debian based Linux distros

# exit on any error
set -e

# check if debian based linux distro
if ! [ `command -v apt` ]; then 
    echo "This script is for Debian based Linux distributions only!"
    exit 1
fi

# check if root
if [ $(id -u) -ne 0 ]; then 
    echo "Run me as root!"
    exit 1
fi

# install wget if not installed
! [ `command -v wget` ] && \
    apt update && apt install wget -y

# check internet connection
wget -q --spider http://google.com
if [ $? -ne 0 ]; then
    echo "You are offline!"
    exit 1
fi

# install alien if not installed
! [ `command -v alien` ] && \
    apt update && apt install alien -y
 

# just in case, but this probably won't happen
[ `command -v zenmap` ] &&  \
    apt remove zenmap -y

# download zenmap
wget https://nmap.org/dist/zenmap-7.92-1.noarch.rpm

# download some dependencies of zenmap to avoid some errors
wget http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-5.1ubuntu2_amd64.deb
wget http://azure.archive.ubuntu.com/ubuntu/pool/universe/p/pygobject-2/python-gobject-2_2.28.6-14ubuntu1_amd64.deb
wget http://security.ubuntu.com/ubuntu/pool/universe/p/pycairo/python-cairo_1.16.2-2ubuntu2_amd64.deb

# convert rpm package to debian package
alien zenmap-7.92-1.noarch.rpm # the output should be: zenmap_7.92-2_all.deb

# install all downloaded .deb files
dpkg -i python-cairo_1.16.2-2ubuntu2_amd64.deb 
dpkg -i python-gobject-2_2.28.6-14ubuntu1_amd64.deb 
dpkg -i python-gtk2_2.24.0-5.1ubuntu2_amd64.deb 
dpkg -i zenmap_7.92-2_all.deb

# finish
rm -v python-cairo_1.16.2-2ubuntu2_amd64.deb 
rm -v python-gobject-2_2.28.6-14ubuntu1_amd64.deb
rm -v python-gtk2_2.24.0-5.1ubuntu2_amd64.deb
rm -v zenmap_7.92-2_all.deb
rm -v zenmap-7.92-1.noarch.rpm

[ `command -v zenmap` ] && echo -e "\n\e[32mDone! \e[0m\nNow try running zenmap by typing: sudo zenmap"

exit 0
