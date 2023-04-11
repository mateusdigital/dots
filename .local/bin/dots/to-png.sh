#!/usr/bin/env bash

function show_usage() {
    echo "to-png <filename>";
    exit 1;
}

readonly name="$1";
test -z "$name" && show_usage;

convert "${name}" "${name%.*}.png";
rm "${name}";