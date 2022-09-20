#!/usr/bin/env bash

##
## Lists all the packages that we installed with:
##    sudo apt-get install
##    sudo apt install
##

## Thanks: https://askubuntu.com/a/250530
(zcat $(ls -tr /var/log/apt/history.log*.gz); cat /var/log/apt/history.log) 2>/dev/null | \
  grep -E '^(Start-Date:|Commandline:)' | \
  grep -v "aptdaemon"                   | \
  grep -E '^Commandline:'               | \
  sed     s/"Commandline: *"//g         | \
  grep -E "^(apt|apt-get) *install"     | \
  sed     s/".*install *"//g            | \
  tr      [:blank:] "\n"                | \
  sort                                    \
  ;
  