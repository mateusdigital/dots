#!/usr/bin/env bash

## Short hand to make things executable...
if (( $# == 1 )); then
    if [ -d "$1" ]; then
        chmod 744 "$1"/*;
    else
        chmod 744 "$1";
    fi;
fi;

chmod 744 "$@";
