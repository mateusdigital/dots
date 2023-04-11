#!/usr/bin/env bash

selected_branch=$(git list-branches            \
                    | sed s#remotes/origin/##g \
                    | sort                     \
                    | uniq                     \
                    | grep -v '\*'             \
                    | grep -v "HEAD ->"        \
                    | peco                     \
                    | tr -d " "                \
                );

test -n "${selected_branch}" && \
    git checkout "${selected_branch}";