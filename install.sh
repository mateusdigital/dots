#!/usr/bin/env bash
##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : install.sh                                                    ##
##  Project   : dots                                                          ##
##  Date      : Oct 08, 2017                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Super, super simple (and inclomple) install script for dots.            ##
##---------------------------------------------------------------------------~##

## @incomplete(stdmatt): Today this only installs the file on the installation 
##  directory, but doesn't make an entry on the .bashrc file (which is needed
##  in order to bash load our stuff).  

##----------------------------------------------------------------------------##
## Variables                                                                  ##
##----------------------------------------------------------------------------##
INSTALL_DIR="$HOME/.stdmatt/dots";

##----------------------------------------------------------------------------##
## Script                                                                     ##
##----------------------------------------------------------------------------##
rm -rf "$INSTALL_DIR";
mkdir "$INSTALL_DIR";

cp -R ./src/* $INSTALL_DIR;
