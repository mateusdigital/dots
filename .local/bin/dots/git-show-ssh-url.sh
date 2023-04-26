#!/usr/bin/env bash

readonly url="$(git url)";

host=$(echo "$url" | cut -d "/" -f 3)
user=$(echo "$url" | cut -d "/" -f 4)
repo=$(echo "$url" | cut -d "/" -f 5)

echo "git@${host}:${user}/${repo}.git"
