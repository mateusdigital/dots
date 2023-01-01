#!/usr/bin/env bash

##
## GNU / LINUX
##

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


## Update
echo "==> Installing GNU/Linux software...";
sudo apt-get update       -y || exit 1;
sudo apt-get upgrade      -y || exit 1;
sudo apt-get dist-upgrade -y || exit 1;

## Add Repositories
sudo add-apt-repository ppa:aslatter/ppa -y || exit 1; ## Alacritty.

for item in ${software_list[@]}; do
    echo "==> Installing ${item}";
    sudo apt-get install -y "${item}" || exit 1;
done;

echo "==> Done...";