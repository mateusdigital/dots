#!/bin/bash

set -e;

readonly has_jq="$(which jq)";
if [ -z "$has_jq" ]; then
	echo "please install jq.";
	exit 1;
fi


readonly username="$(git config user.name)";

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
