#!/usr/bin/env bash

set -e; ## Stop on errors.

echo "Installing core dependencies...";
sudo apt-get install -y \
    atool               \
    curl                \
    ed                  \
    git                 \
    grep                \
    net-tools           \
    openssh-server      \
    peco                \
    tree                \
    wget                \
    whois               \
    xsel                \
    ;
