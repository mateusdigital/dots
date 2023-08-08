#!/usr/bin/env bash

readonly SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

## Update
echo "==> Installing GNU/Linux software...";

echo "$SCRIPT_DIR";
readonly is_wsl="$(uname -a | grep WSL)";

sudo apt-get update       -y;
sudo apt-get upgrade      -y;
sudo apt-get dist-upgrade -y;

for item in $@; do
    echo "${SCRIPT_DIR}/dependencies/${item}.sh";
    "${SCRIPT_DIR}/dependencies/${item}.sh"
done;

sudo apt-get auto-remove -y;
echo "==> Done...";
