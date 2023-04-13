#!/usr/bin/bash

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
readonly FONT_SRC_DIR="$SCRIPT_DIR";
readonly FONT_DST_DIR="${HOME}/.local/share/fonts";

mkdir -p "$FONT_DST_DIR";
find "$FONT_SRC_DIR" -type f \( -iname "*.oft" -o -iname "*.ttf" \) -print0 | while read -d $'\0' font; do
    echo "===> Installing: $font";
    cp "$font" "$FONT_DST_DIR";
done

sudo fc-cache -f -v;