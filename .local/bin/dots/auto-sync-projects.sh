#!/usr/bin/env bash

set -e; ## break on errors.


readonly PROJECTS_DIR="${HOME}/Projects";
if [ ! -d "${PROJECTS_DIR}" ]; then
    echo "Missing projects dir - Aborting...";
    exit 1;
fi;

for item in $(find "${PROJECTS_DIR}" -type d -name ".git" -printf '%h\n'); do
    pushd $item > /dev/null;
        git_result="$(git status)";
        is_behind="$(echo "$git_result" | grep "Your branch is behind")";
        is_ahead="$(echo "$git_result" | grep "Your branch is ahead")";

        if [ -n "$is_behind" ]; then
            echo "---> Pulling $item";
            git pull;
        fi;

        if [ -n "$is_ahead" ]; then
            echo "---> Pushing $item";
            git push --tags;
        fi
    popd > /dev/null;
done;
