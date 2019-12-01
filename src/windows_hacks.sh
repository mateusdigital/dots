##------------------------------------------------------------------------------
__Windows_Hack_Set_PATH()
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

    PATH="$WINDOWS_PATH";
}

##------------------------------------------------------------------------------
__Windows_Hack_Set_Aliases()
{
    alias python27="/c/Python27/python";
    alias python38="";
}

python3()
{
    /c/Python38/python "$@";
}

##------------------------------------------------------------------------------
if [ "$(pw_os_get_simple_name)" == "$(PW_OS_WINDOWS)" ]; then
    __Windows_Hack_Set_PATH;
    __Windows_Hack_Set_Aliases;
fi;