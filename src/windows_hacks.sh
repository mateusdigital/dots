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
    export MANPDF_READER="/mnt/c/Program Files (x86)/Foxit Software/Foxit Reader/FoxitReader.exe"
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
if [ "$(pw_os_get_simple_name)" == "$(PW_OS_WINDOWS)" ]; then
    __Windows_Hacks_Set_PATH;
elif [ "$(pw_os_get_simple_name)" == "$(PW_OS_WSL)" ]; then
    echo "Doing WSL hacks..";
    __WSL_Hacks_Create_Exports;
    __WSL_Hacks_Create_Aliases;


## @XXX(stdmatt): VERY VERY NASTY WAY TO ACCESS DOCKER from WSL...
docker() {

    local DOCKER_WINDOWS_PATH="C:/Program Files/Docker/Docker/resources/bin/docker.exe";
    local DOCKER_WSL_PATH="$(wslpath  "$DOCKER_WINDOWS_PATH")";
    "$DOCKER_WSL_PATH" $@
}
fi;
