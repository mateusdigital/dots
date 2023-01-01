#!/usr/bin/env bash

echo "==> Installing mateus-earth's dots!";
echo "==> Clonning repo...";
git clone --bare https://github.com/mateus-earth/dots "${HOME}/.dots-bare" || exit 1;
git --git-dir="${HOME}/.dots-bare" --work-tree="${HOME}" checkout || exit 1;
echo "==> Done...";