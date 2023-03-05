#!/usr/bin/env bash
set -e

readonly directory="$1";
readonly repos="$(repochecker --short --show-all --submodule "${directory}"    \
                 | grep "\[Repo\]"                                             \
                 | cut -d ":" -f2                                              \
                 | tr -d " " | tr -d "\(\)"                                    \
                )";

for item in $repos; do
    pushd "${item}";
    echo "---> ${item} : (${PWD})";
    read;

    gitui;
    popd;
done;