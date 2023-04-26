#!/usr/bin/env bash

set -e; ## Stop on errors.


## Add Repositories
sudo add-apt-repository ppa:aslatter/ppa -y; ## Allacritty
sudo apt-get update;

## Install Packages
sudo apt-get install -y \
    alacritty           \
    firefox             \
    ;

## Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm   ./google-chrome-stable_current_amd64.deb

## VSCODE
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code
