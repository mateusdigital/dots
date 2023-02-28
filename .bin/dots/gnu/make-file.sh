#!/usr/bin/env bash

function show_usage() {
    echo -e "Usage:\n   make-file.sh <path/to/the/file.ext>";
    exit 1;
}

test -z "$1" && show_usage;

filename="$(basename  "$1")";
foldername="$(dirname "$1")";

mkdir -p "${foldername}";
touch "${foldername}/${filename}";

echo "---> File touch(1)ed at: ${foldername}/${filename}";