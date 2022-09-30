#!/usr/bin/env bash



declare -r SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")";



fonts=$(find "${SCRIPT_DIR}" -iname "*.ttf");

if uname -a | grep -q "WSL"; then
    # script_filename="install-dev-fonts.ps1";
    # script_temp_dir="$(wslpath -u "$(pwsh.exe -c "echo \$env:TEMP" | tr -d [:space:])")"; ## @XXX(mesquita): Assuming that username hasn't spaces...

    # ## @notice: We can't exec the file in poweshell if the file is on the
    # ## WSL filesystem due some sort of powershell execution access policy...
    # ## Don't want to dive onto that right now, and don't want to change the
    # ## police of all the scripts...
    # ## So the easiest way is to just copy the
    # cp -fv "${SCRIPT_DIR}/${script_filename}" "${script_temp_dir}";

    # win_temp_dir="$(wslpath -m "${script_temp_dir}")";
    # pwsh.exe -f "${win_temp_dir}/${script_filename}" "";

    for font in "$fonts"; do
        echo $(wslpath -m "$font");
    done;
    # contents=$(cat "${SCRIPT_DIR}/${script_filename}");
    # pwsh.exe -c "${contents} Ola";
fi;
