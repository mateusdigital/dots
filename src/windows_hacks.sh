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
    echo "Doing WSL hacks...";

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
            ## @TODO(stdmatt): Probably we want to have this not hardcoded
            ## or remove it at all...
            export MANPDF_READER="/mnt/c/Program Files (x86)/Foxit Software/Foxit Reader/FoxitReader.exe";
        fi;

        ## Display
        export DISPLAY=:0
    }

    ##--------------------------------------------------------------------------
    __WSL_Hacks_Create_Aliases()
    {
        ## @TODO(stdmatt): Clean this if not needed anymore...
        # ## Git Bash.
        # local GIT_BASH_WINDOWS_PATH="C:/Git/bin/bash.exe";
        # local GIT_BASH_WSL_PATH="$(wslpath $GIT_BASH_WINDOWS_PATH)";

        # alias git-bash="$GIT_BASH_WSL_PATH ";

        ## Powershell.
        alias powershell="powershell.exe ";
    }

    ##
    ## @XXX Do we want this???
    ##    -stdmatt, Aug 28, 2020.
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

    ##
    ## Run stuff that we need to make the WSL work
    ##
    __WSL_Hacks_Set_PATH;
    __WSL_Hacks_Create_Exports;
    __WSL_Hacks_Create_Aliases;
    __WSL_Hacks_Map_Root_To_Windows_Drive;

    wsl_init_xserver;
fi;
