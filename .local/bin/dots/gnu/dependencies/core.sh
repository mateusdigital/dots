#!/usr/bin/env bash

set -e; ## Stop on errors.

sudo apt-get install -y \
    atool               \
    automake            \
    build-essential     \
    cmake               \
    coreutils           \
    curl                \
    diffutils           \
    ed                  \
    findutils           \
    gawk                \
    gdb                 \
    gpg                 \
    gimp                \
    git-gui             \
    git                 \
    grep                \
    jq                  \
    lynx                \
    make                \
    net-tools           \
    openssh-server      \
    pandoc              \
    peco                \
    ripgrep             \
    shellcheck          \
    tree                \
    wget                \
    whois               \
    youtube-dl          \
    xsel                \
    ;


##
## Custom Software
##

## Nodejs
if [ -z "$(which node)" ]; then 
    curl -sL https://deb.nodesource.com/setup_18.x -o /var/tmp/nodesource_setup.sh
    sudo bash /var/tmp/nodesource_setup.sh;
    sudo apt-get install -y nodejs
fi;

sudo npm install -g \
    live-server     \
    ;