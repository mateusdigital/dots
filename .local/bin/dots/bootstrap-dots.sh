#!/usr/bin/env bash
##~---------------------------------------------------------------------------##
##                               *       +                                    ##
##                         '                  |                               ##
##                     ()    .-.,="``"=.    - o -                             ##
##                           '=/_       \     |                               ##
##                        *   |  '=._    |                                    ##
##                             \     `=./`,        '                          ##
##                          .   '=.__.=' `='      *                           ##
##                 +                         +                                ##
##                      O      *        '       .                             ##
##                                                                            ##
##  File      : bootstrap-dots.sh                                             ##
##  Project   : dots                                                          ##
##  Date      : 2023-04-11                                                    ##
##  License   : GPLv3                                                         ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2023                                         ##
##                                                                            ##
##  Description :                                                             ##
##   Install dots on the system.                                              ##
##     curl -s <url> | bash                                                   ##
##---------------------------------------------------------------------------~##

echo "==> Installing Mateus Mesquita's dots!";

set -o errexit ## fail script if command fails. add "|| true" to commands that you allow to fail
set -o nounset ## exit if undeclared variables are used

readonly DOTS_DIR="${HOME}/.dots-bare";

##------------------------------------------------------------------------------
## Check pre conditions.
if [ -d "$DOTS_DIR" ]; then
    echo "==> Already has dots downloaded...";
    exit;
fi;

if [ -f "${HOME}/.bashrc" ]; then
    echo ""${HOME}/.bashrc" present - Backup and remove it...";
    exit;
fi;

if [ -f "${HOME}/.profile" ]; then
    echo ""${HOME}/.profile" present - Backup and remove it...";
    exit;
fi;



##------------------------------------------------------------------------------
echo "==> Clonning repo...";

function _git() {
    git --git-dir="${DOTS_DIR}" --work-tree="${HOME}" $@;
}

git clone --bare https://github.com/mateusdigital/dots "${HOME}/.dots-bare";
_git checkout;

##------------------------------------------------------------------------------
echo "==> Setting config...";
_git config --local status.showUntrackedFiles no;                        ## Reduce noise.
_git config --local core.excludesfile "${HOME}/.config/.dots_gitignore"; ## Custom gitignore.

echo "==> Done...";