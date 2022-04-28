#!/bin/env bash

_say() {
    echo "--------------------------------------------------------------------------------"
    echo "-- $@"
    echo "--------------------------------------------------------------------------------"
}

##------------------------------------------------------------------------------
_say "Installing homebrew...";

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

##------------------------------------------------------------------------------
_say "Going to powershell...";

pwsh -File $HOME/.config/bootstrap/gnu/setup_server.ps1
exit;

##------------------------------------------------------------------------------
_say "Update";

sudo apt-get update       -y;
sudo apt-get upgrade      -y;
sudo apt-get dist-upgrade -y;

##------------------------------------------------------------------------------
_say "Setup Firewall";

sudo ufw app list
yes | sudo ufw enable
sudo ufw status
sudo ufw allow OpenSSH
sudo ufw allow ssh   ## (Port 22)
sudo ufw allow http  ## (Port 80)
sudo ufw allow https ## (Port 443)

##------------------------------------------------------------------------------
_say "Install stuff...";
sudo apt-get install -y build-essential git;


##------------------------------------------------------------------------------
_say "Install node...";

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs;

##------------------------------------------------------------------------------
_say "Install powershell...";

sudo apt-get install -y wget apt-transport-https software-properties-common

wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update -y
rm packages-microsoft-prod.deb

sudo apt-get install -y powershell


##------------------------------------------------------------------------------
_say "Clonning dots";

git clone --bare "https://gitlab.com/stdmatt-personal/dots" "$HOME/.dots";
git --git-dir=$HOME/.dots/ --work-tree=$HOME checkout;


