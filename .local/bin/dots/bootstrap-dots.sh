#!/usr/bin/env bash


echo "==> Installing Mateus Mesquita's dots!";

set -o errexit ## fail script if command fails. add "|| true" to commands that you allow to fail
set -o nounset ## exit if undeclared variables are used
#set -o xtrace ## trace that which has been executed. uncomment for debugging


##------------------------------------------------------------------------------
echo "==> Clonning repo...";

function _git() {
    git --git-dir="${HOME}/.dots-bare" --work-tree="${HOME}" $@;
}

git clone --bare https://github.com/mateusdigital/dots "${HOME}/.dots-bare";
_git checkout;

##------------------------------------------------------------------------------
echo "==> Setting config...";
_git config --local status.showUntrackedFiles no;                        ## Reduce noise.
_git config --local core.excludesfile "${HOME}/.config/.dots_gitignore"; ## Custom gitignore.

echo "==> Done...";