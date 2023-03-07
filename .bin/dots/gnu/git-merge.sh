#!/usr/bin/env bash
set -e

current_branch=$(git list-branches | grep "\*" | tr -d " " | tr -d "\*");
branch_to_merge=$(git list-branches           \
                    | grep -v "remotes/"      \
                    | grep -v "\*"            \
                    | peco --prompt "Branch?" \
                    | tr -d " "
                    );

if [ -z "${branch_to_merge}" ]; then
    echo "--> Ignoring...";
    exit;
fi;

echo "--> Merging into ${branch_to_merge} <- from ${current_branch}...";
test -z "$@" && echo "--> Args: $*";

git checkout            "${branch_to_merge}";
git merge --no-ff "$@" "${current_branch}";

echo "--> Merged...";
