##------------------------------------------------------------------------------
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

##------------------------------------------------------------------------------
__Windows_Hacks_Create_Links()
{
    ## XXX(stdmatt): Is this needed???
    ln -f /c/Python38/python.exe /c/Python38/python3.exe
}

##------------------------------------------------------------------------------
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
    export DISPLAY=:0
}

##------------------------------------------------------------------------------
__WSL_Hacks_Create_Aliases()
{
    local GIT_BASH_WINDOWS_PATH="C:/Git/bin/bash.exe";
    local GIT_BASH_WSL_PATH="$(wslpath $GIT_BASH_WINDOWS_PATH)";

    alias git-bash="$GIT_BASH_WSL_PATH ";
    alias powershell="powershell.exe ";
}

##------------------------------------------------------------------------------
##
## Hacks for Mingw.
if [ "$(pw_os_get_simple_name)" == "$(PW_OS_WINDOWS)" ]; then
    __Windows_Hacks_Set_PATH;
##
## Hacks for WSL.
elif [ "$(pw_os_get_simple_name)" == "$(PW_OS_WSL)" ]; then
    echo "Doing WSL hacks..";

    __WSL_Hacks_Create_Exports;
    __WSL_Hacks_Create_Aliases;

wsl_init_xserver()
{
    local XSERVER_WINDOWS_PATH="C:/Xming/Xming.exe";
    local XSERVER_WSL_PATH="$(wslpath "$XSERVER_WINDOWS_PATH")";

    local IS_RUNNING="$(tasklist.exe | grep Xming.exe)";
    if [ -n "$IS_RUNNING" ]; then
        pw_func_log "Already running...";
        return 0;
    fi;

    "$XSERVER_WSL_PATH" ":0" -clipboard -multiwindow > /dev/null 2>1 &
    pw_func_log "Done...";
}

## @(XXX) VSCode hangs when the debugger is stopped...
kill_debugger()
{
    ps aex | grep python | cut -d " " -f1 | xargs kill -9
}

## @XXX(stdmatt): VERY VERY NASTY WAY TO ACCESS DOCKER from WSL...
docker() {

    local DOCKER_WINDOWS_PATH="C:/Program Files/Docker/Docker/resources/bin/docker.exe";
    local DOCKER_WSL_PATH="$(wslpath  "$DOCKER_WINDOWS_PATH")";
    "$DOCKER_WSL_PATH" $@
}
fi;
