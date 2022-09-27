#!/usr/bin/env bash

##
## Update, upgrade and then install all the packages on the system.
## Nothing more than a big list of "required" packages to all machines....
##



sudo apt-get update  -y && \
sudo apt-get upgrade -y && \
sudo apt-get install -y    \
    alacritty              \
    atool                  \
    cmake                  \
    build-essential        \
    firefox                \
    gdb                    \
    gimp                   \
    libgimp2.0-dev         \
    libgtk-3-dev           \
    libgtkmm-3.0-dev       \
    libsdl2-*              \
    net-tools              \
    shellcheck             \
    whois                  \
;
