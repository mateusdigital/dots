##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : windows_hacks.sh                                              ##
##  Project   : dots                                                          ##
##  Date      : Dec 01, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2019, 2020                                            ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##


##----------------------------------------------------------------------------##
## Hacks for Mingw                                                            ##
##----------------------------------------------------------------------------##
if [ "$(pw_os_get_simple_name)" == "$(PW_OS_WINDOWS)" ]; then
    ##--------------------------------------------------------------------------
    __Windows_Hacks_Set_PATH()
    {
        local WINDOWS_PATH="";
        ## Unix-Like stuff...
            WINDOWS_PATH+="/mingw64/bin:";
            WINDOWS_PATH+="/usr/bin:";
            WINDOWS_PATH+="/usr/local/bin:";
            WINDOWS_PATH+="/cmd:";
        ## Windows stuff...
            WINDOWS_PATH+="/c/WINDOWS/system32:";
            WINDOWS_PATH+="/c/WINDOWS:";
            WINDOWS_PATH+="/c/WINDOWS/System32/Wbem:";
            WINDOWS_PATH+="/c/WINDOWS/System32/WindowsPowerShell/v1.0:";
            WINDOWS_PATH+="/c/WINDOWS/System32/OpenSSH:";
        ## Python...
            WINDOWS_PATH+="/c/Python27:";
            WINDOWS_PATH+="/c/Python27/Scripts:";
            WINDOWS_PATH+="/c/Python38:";
            WINDOWS_PATH+="/c/Python38/Scripts:";
        ## Installed Applications...
            WINDOWS_PATH+="/c/CMake/bin:";
            WINDOWS_PATH+="/c/VSCodium/bin:";
            WINDOWS_PATH+="/c/LLVM/bin:"

        PATH="$WINDOWS_PATH";
    }

    ##--------------------------------------------------------------------------
    __Windows_Hacks_Create_Links()
    {
        ## XXX(stdmatt): Is this needed???
        ln -f /c/Python38/python.exe /c/Python38/python3.exe
    }


    __Windows_Hacks_Set_PATH;


##----------------------------------------------------------------------------##
## Hacks for WSL                                                              ##
##----------------------------------------------------------------------------##
elif [ "$(pw_os_get_simple_name)" == "$(PW_OS_WSL)" ]; then
    echo "Doing WSL hacks..";

    ## @XXX(stdmatt): Really shit, but working....
    __WSL_Hacks_Escape_Path()
    {
        local ARGS="$@";
        local ESCAPED_PATH="";

        for word in "$ARGS"; do
            for (( i=0; i<${#word}; i++ )); do
                c="${word:$i:1}";
                case "$c" in
                    " ") ESCAPED_PATH+="\ "; ;;
                    ")") ESCAPED_PATH+="\)"; ;;
                    "(") ESCAPED_PATH+="\("; ;;
                     * ) ESCAPED_PATH+="$c"; ;;
                esac;
            done;
        done;

        echo "$ESCAPED_PATH"
    }

    ##--------------------------------------------------------------------------
    __WSL_Hacks_Set_PATH()
    {
        local USER_HOME=$(pw_find_real_user_home);
        local USER_BIN_DIR="${USER_HOME}/.stdmatt_bin/wsl";
        PATH="${PATH}:${USER_BIN_DIR}";
    }
    ##--------------------------------------------------------------------------
    __WSL_Hacks_Create_Exports()
    {
        ## manpdf
        ## todo(stdmatt): Find a way to define this setting in a more general way
        local OKULAR_PATH=$(pw_get_program_path "okular");
        if [ -n "$OKULAR_PATH" ]; then
            export MANPDF_READER="$OKULAR_PATH";
        else
            export MANPDF_READER="/mnt/c/Program Files (x86)/Foxit Software/Foxit Reader/FoxitReader.exe";
        fi;

        ## Display
        export DISPLAY=:0
    }

    ##--------------------------------------------------------------------------
    __WSL_Hacks_Create_Aliases()
    {
        ## Git Bash.
        local GIT_BASH_WINDOWS_PATH="C:/Git/bin/bash.exe";
        local GIT_BASH_WSL_PATH="$(wslpath $GIT_BASH_WINDOWS_PATH)";

        alias git-bash="$GIT_BASH_WSL_PATH ";

        ## Powershell.
        alias powershell="powershell.exe ";
    }

    __WSL_Hacks_Map_Root_To_Windows_Drive()
    {
        subst.exe "U:" "$(wslpath -aw /)";
    }

    ##
    ## Public Functions
    ##

    ##--------------------------------------------------------------------------
    wsl_init_xserver()
    {
        local XSERVER_WINDOWS_PATH="C:/Xming/Xming.exe";
        local XSERVER_WSL_PATH="$(wslpath "$XSERVER_WINDOWS_PATH")";

        local IS_RUNNING="$(tasklist.exe | grep Xming.exe)";
        if [ -n "$IS_RUNNING" ]; then
            pw_func_log "Already running...";
            return 0;
        fi;

        "$XSERVER_WSL_PATH" ":0" -clipboard -multiwindow 2>&1 1>/dev/null  &
        pw_func_log "Done...";
    }

    ##--------------------------------------------------------------------------
    ## @(XXX) VSCode hangs when the debugger is stopped...
    kill_debugger()
    {
        ps aex | grep python | cut -d " " -f1 | xargs kill -9
    }

    devenv()
    {
        ## Get where visual studio is installed as a Windows path
        ## and clean the path the most as possible.
        local DEVENV_WINDOWS_PATH="$(vswhere.exe -latest | grep "productPath")";
        DEVENV_WINDOWS_PATH="$(pw_string_replace "$DEVENV_WINDOWS_PATH" "productPath:" " ")";
        DEVENV_WINDOWS_PATH="$(pw_trim_left      "$DEVENV_WINDOWS_PATH")";

        ## Transform the windows path to a unix path.
        local DEVENV_WSL_PATH="$(wslpath -u "$DEVENV_WINDOWS_PATH")";
        DEVENV_WSL_PATH="$(dirname "$DEVENV_WSL_PATH")";

        ## Now the hack... Visual Studio doesn't accept the "network" path
        ## that windows sees the WSL filesystem, so since we have the root
        ## of the WSL filesystem subst'ed at the U: we need to replace the
        ## command line args paths with this drive letter.
        ## This way we'll be able to fool visual studio to load the directory
        ## thing for us ;D
        local ROOT_NETWORK_PATH="$(wslpath -am /)";
        local ARG_NETWORK_PATH="$(wslpath -am $1)";
        local ARG_FAKE_PATH="U:/$(pw_substr "$ARG_NETWORK_PATH" $(pw_strlen "$ROOT_NETWORK_PATH"))";

        "$DEVENV_WSL_PATH/devenv.exe" "$ARG_FAKE_PATH";
    }


    ##--------------------------------------------------------------------------
    ## @XXX(stdmatt): VERY VERY NASTY WAY TO ACCESS DOCKER from WSL...
    docker()
    {
        local DOCKER_WINDOWS_PATH="C:/Program Files/Docker/Docker/resources/bin/docker.exe";
        local DOCKER_WSL_PATH="$(wslpath  "$DOCKER_WINDOWS_PATH")";
        "$DOCKER_WSL_PATH" $@
    }

    ##
    ## Run stuff that we need to make the WSL work
    ##
    __WSL_Hacks_Set_PATH;
    __WSL_Hacks_Create_Exports;
    __WSL_Hacks_Create_Aliases;
    __WSL_Hacks_Map_Root_To_Windows_Drive;

    wsl_init_xserver;
fi;
