#!/usr/bin/env bash

INSTALL_DIR="$HOME/.stdmatt/dots";

rm -rf "$INSTALL_DIR";
mkdir "$INSTALL_DIR";

cp -R ./src/* $INSTALL_DIR;
