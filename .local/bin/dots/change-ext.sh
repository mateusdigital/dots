#!/usr/bin/env bash
set -e;

readonly filename="$1";
readonly new_ext="$2";

if [ -f "$filename" ]; then
    mv -v "${filename}" "${filename%.*}.${new_ext}";
fi;
