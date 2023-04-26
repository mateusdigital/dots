#!/usr/bin/env bash

readonly SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

## Update
echo "==> Installing GNU/Linux software...";

echo "$SCRIPT_DIR";
readonly is_wsl="$(uname -a | grep WSL)";

sudo apt-get update       -y;
sudo apt-get upgrade      -y;
sudo apt-get dist-upgrade -y;

if [ -n "$is_wsl" ]; then 
    echo "---> Installing for WSL";
    "${SCRIPT_DIR}"/dependencies/core.sh;
else 
    echo "---> Installing for Desktop";
    "${SCRIPT_DIR}"/dependencies/core.sh;
    "${SCRIPT_DIR}"/dependencies/desktop.sh;
fi;

sudo apt-get auto-remove -y;
echo "==> Done...";
