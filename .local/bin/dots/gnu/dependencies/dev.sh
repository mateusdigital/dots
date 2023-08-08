#!/usr/bin/env bash

set -e; ## Stop on errors.

echo "Installing dev dependencies...";
sudo apt-get install -y \
    automake            \
    build-essential     \
    cmake               \
    coreutils           \
    diffutils           \
    findutils           \
    gawk                \
    gdb                 \
    gpg                 \
    gimp                \
    git-gui             \
    jq                  \
    make                \
    pandoc              \
    shellcheck          \
    sshfs               \
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