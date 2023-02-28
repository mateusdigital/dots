#!/usr/bin/env bash

for item in "$@"; do
    echo "---> Ignoring $item";
    echo "$item" >> .gitignore;
done
