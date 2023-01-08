#!/usr/bin/env bash

echo "==> Installing mateus-earth's dots!";
set -o errexit ## fail script if command fails. add "|| true" to commands that you allow to fail
set -o nounset ## exit if undeclared variables are used
#set -o xtrace ## trace that which has been executed. uncomment for debugging
echo "==> Clonning repo...";
git clone --bare https://github.com/mateus-earth/dots "${HOME}/.dots-bare" || exit 1;
git --git-dir="${HOME}/.dots-bare" --work-tree="${HOME}" checkout || exit 1;
echo "==> Done...";

\ No newline at end of file
