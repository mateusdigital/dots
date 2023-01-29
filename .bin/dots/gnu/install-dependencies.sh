#!/usr/bin/env bash

##
## GNU / LINUX
##

## Update
echo "==> Installing GNU/Linux software...";
sudo apt-get update       -y || exit 1;
sudo apt-get upgrade      -y || exit 1;
sudo apt-get dist-upgrade -y || exit 1;

## Add Repositories
sudo add-apt-repository ppa:aslatter/ppa -y || exit 1; ## Alacritty.

## Install
readonly software_list=(
    "alacritty"
    "atool"
    "automake"
    "build-essential"
    "cmake"
    "coreutils"
    "curl"
    "diffutils"
    "ed"
    "exa"
    "fd-find"
    "findutils"
    "firefox"
    "gawk"
    "gdb"
    "gimp"
    "git-gui"
    "git"
    "grep"
    "lynx"
    "make"
    "net-tools"
    "pandoc"
    "peco"
    "ripgrep"
    "shellcheck"
    "tree"
    "vifm"
    "wget"
    "whois"
    "youtube-dl"
    "xsel"
);

for item in ${software_list[@]}; do
    echo "==> Installing ${item}";
    sudo apt-get install -y "${item}" || exit 1;
done;


##
## Custom Software
##

## Starship
if [ -z "$(which starship)" ]; then
    echo "==> Installing starship...";

    curl -sS https://starship.rs/install.sh > /var/tmp/starship_install.sh;
    chmod 744 /var/tmp/starship_install.sh;    ## @clean: All this is just to pass --force
    sudo /var/tmp/starship_install.sh --force; ##      mateus - 23-01-02
fi;

## Nodejs
curl -sL https://deb.nodesource.com/setup_18.x -o /var/tmp/nodesource_setup.sh
sudo bash /var/tmp/nodesource_setup.sh;
sudo apt-get install -y nodejs


echo "==> Done...";