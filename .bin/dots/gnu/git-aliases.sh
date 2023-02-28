#!/usr/bin/env bash
echo $COLUMNS

terminal_width=$(tput cols);
minimum_spaces=30;
available_space=$(( terminal_width - minimum_spaces -1));

while IFS= read -r line; do
    head="$(echo "$line" | cut -d " " -f 1)";
    tail="$(echo "$line" | cut -d " " -f 2-)";

    printf "%-${minimum_spaces}s %s\n" "$head" "${tail:0:$available_space}";
done <<< "$(git config --get-regexp alias | sort | sed s/"  "/""/g)";
