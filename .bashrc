if [ -f "${HOME}/.config/bash/main.sh" ]; then
    . "${HOME}/.config/bash/main.sh";
else
    echo "Failed to load profile!";
fi;

