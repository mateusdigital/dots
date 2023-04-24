#!/bin/bash

set -e;

readonly username="mateus-earth";

url_type="ssh_url";
if [ "$1" == "--http" ]; then
    url_type="html_url";
fi;

readonly repos=$(curl -s "https://api.github.com/users/${username}/repos" | jq -r ".[].${url_type}")

mkdir -p "${HOME}/Projects";
cd "${HOME}/Projects";

for repo in $repos; do
    echo "==> $repo";
    git clone --recurse-submodules --tags "$repo";
done
