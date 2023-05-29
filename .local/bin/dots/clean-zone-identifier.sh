#!/usr/bin/env bash
target="$1";
if [ -z "$target" ]; then
    target=".";
fi
find "$target" -iname "*Zone.Identifier*" -delete;