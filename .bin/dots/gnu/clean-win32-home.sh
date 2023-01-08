#!/usr/bin/env bash

if [ -z "$(uname -a | grep WSL)" ]; then
    echo "$0 not running in WSL - Exiting...";
    exit 1;
fi;

## Clean all the links to folders that we don"t care on the ## C:/Users/USERNAME.
## For now just works on the Brazilian Portuguese version of Windows 11.
## 	mateus - 22-09-14

USERNAME=$(whoami); ## @XXX: Make sure that Windows username is the same as the WSL one.

cd "/mnt/c/Users/$USERNAME/";

rm -rf                       \
    "Ambiente de Rede"       \
    "Ambiente de Impressão"  \
    "Configurações Locais"   \
    "Favorites"	             \
    "Cookies"                \
    "Menu Iniciar"           \
    "Modelos"                \
    "Contacts"               \
    "Links"                  \
    "Dados de Aplicativos"   \
    "Meus Documentos"        \
    "Saved Games"            \
    "Recent"                 \
    "SendTo"                 \
    "Searches"               \
    ;
