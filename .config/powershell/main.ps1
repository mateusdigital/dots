

$SCRIPT_DIR = (Split-Path -Parent $MyInvocation.MyCommand.Path);

## 
## Load Prequisites.
## 

. "${SCRIPT_DIR}/environment.ps1";
. "${SCRIPT_DIR}/directories.ps1";
. "${SCRIPT_DIR}/remove_default_aliases.ps1";


##
## Load shlib :)
##

. "${DOTS_SHLIB_DIR}/shlib.ps1"; ## Load shlib.

##
## Load things!!!
##

##------------------------------------------------------------------------------
. "${SCRIPT_DIR}/version.ps1";         ## Show version and copyright.

. "${SCRIPT_DIR}/path.ps1";            ## Setup our $PATH.
. "${SCRIPT_DIR}/pwsh_modules.ps1";    ## Load the Powershell modules.

. "${SCRIPT_DIR}/network_utils.ps1";   ## Network utilities.
. "${SCRIPT_DIR}/shell_utils.ps1";     ## Utilities for shell usage.

. "${SCRIPT_DIR}/custom_prompt.ps1";   ## Customize our PS1.
. "${SCRIPT_DIR}/dots_function.ps1";   ## Make dots a function.

## Load OS Dependent things...
if((sh_is_windows_or_wsl)) { 
    . "${SCRIPT_DIR}/win32.ps1"; 
}