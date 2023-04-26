#!/usr/bin/env bash
set -e;

readonly WHO_AM_I="$(git whoami)";
readonly DIRNAME="${HOME}/.ssh";
readonly FILENAME="${DIRNAME}/id_ed25519.pub";

mkdir -p "${DIRNAME}";

## Generate a new ssh key.
if [ ! -f "${FILENAME}" ]; then
    echo "==> Creating ssh key for: (${WHO_AM_I})";

    ssh-keygen -t ed25519 -C "${WHO_AM_I}";
    ssh-add "${FILENAME}";
fi;

## Make sure that the keys directory has the least amount access possible...
chmod 600 -R "${DIRNAME}/"*;


cat "${FILENAME}";
if [ -n "$(which xsel)" ]; then  ## gnu
	cat "${FILENAME}" | xsel --input --clipboard;
	echo "==> Copied to clipboard...";
elif [ -n "$(which pbcopy)" ]; then  ## mac
	cat "${FILENAME}" | pbcopy;
	echo "==> Copied to clipboard...";
fi
