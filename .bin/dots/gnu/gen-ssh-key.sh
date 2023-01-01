#!/usr/bin/env bash

## Generate a new ssh key.
readonly WHO_AM_I="$(git whoami)";
readonly FILENAME="${HOME}/.ssh/id_ed25519";

if [ ! -f "${FILENAME}" ]; then
    echo "==> Creating ssh key for: (${WHO_AM_I})";

    ssh-keygen -t ed25519 -C "${WHO_AM_I}";
    ssh-add "${FILENAME}";
fi;

cat "${FILENAME}" | xsel --input --clipboard;
echo "==> Copied to clipboard...";