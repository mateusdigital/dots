#!/usr/bin/env bash

set -e; ## break on errors.

readonly wsl_home="$(wslpath -au "C:/Users/$USER/")";

cp -v "${HOME}/.gitconfig" "${wsl_home}";