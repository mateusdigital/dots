#!/bin/env bash
if [ "$(uname)" != "linux" ]; then
    "Unsupported platform...";
fi;

_say() {
    echo "--------------------------------------------------------------------------------"
    echo "-- $@"
    echo "--------------------------------------------------------------------------------"
}

##------------------------------------------------------------------------------
_say "Setup Firewall";

sudo ufw app list
yes | sudo ufw enable
sudo ufw status
sudo ufw allow OpenSSH
sudo ufw allow ssh   ## (Port 22)
sudo ufw allow http  ## (Port 80)
sudo ufw allow https ## (Port 443)


##------------------------------------------------------------------------------
_say "Update";

sudo apt-get update       -y;
sudo apt-get upgrade      -y;
sudo apt-get dist-upgrade -y;


##------------------------------------------------------------------------------
_say "Install stuff...";

sudo apt-get install -y build-essential git;

##------------------------------------------------------------------------------
_say "Clonning dots";

git clone --bare "https://gitlab.com/stdmatt-personal/dots" "$HOME/.dots";
git --git-dir=$HOME/.dots/ --work-tree=$HOME checkout;

. "${HOME}/.config/bash/bashy.sh";


##------------------------------------------------------------------------------
_say "Installing homebrew...";

## Homebrew itself...
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Packages...
brew_packages=(
    "gcc"
    "atool"
    "curl"
    "coreutils"
    "diffutils"
    "ed"
    "findutils"
    "git"
    "gitui"
    "fd"
    "gawk"
    "grep"
    "libtool"
    "lynx"
    "ripgrep"
    "tree"
    "vifm"
    "wget"
);

for $item in ${brew_packages[@]}; do
    brew install $item;
done;


##------------------------------------------------------------------------------
_say "Install node...";

## Nodejs itself...
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs;

##------------------------------------------------------------------------------
_say "Install python things...";

python3 -m pip install shellhistory

