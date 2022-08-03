

$SCRIPT_DIR = (Split-Path -Parent $MyInvocation.MyCommand.Path);

## 
## Load Prequisites.
## 

. "${SCRIPT_DIR}/environment.ps1";
. "${SCRIPT_DIR}/directories.ps1";



##
## Ensure dependencies 
##
 
$DOTS_FORCE_INSTALL = $false; ## If we should install dependencies if we met them.

##------------------------------------------------------------------------------
$has_shlib       = (Test-Path "${SHLIB_DIR}/shlib.ps1");
$has_ps_readline = (Get-InstalledModule).Name.Contains("PSReadLine");
$has_ps_fzf      = (Get-InstalledModule).Name.Contains("PSFzf");
$force_install   = $DOTS_FORCE_INSTALL;

if($force_install -or (-not $has_shlib)) { 
    if(-not (Test-Path "${TEMP_DIR}/shlib")) {
        git clone "https://gitlab.com/mateus-earth-libs/pwsh/shlib" "${TEMP_DIR}/shlib";
    }
    
    & "${TEMP_DIR}/shlib/install.ps1";
}

if($force_install -or (-not $has_ps_readline)) { 
    echo "Installing PSReadline...";
    Install-Module PSReadLine -AllowPrerelease -Force;
}

if($force_install -or (-not $has_ps_fzf)) {
    echo "Installing PSFzf...";

    if(-not (Test-Path "${HOME}/.fzf")) {
        git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf";
    }

    $false | & "${HOME}/.fzf/install" --xdg; ## We don't want to install nothing extra...
    
    echo "Installing module...";
    Install-Module -Name PSFzf;
}


##
## Load shlib :)
##

. "${SHLIB_DIR}/shlib.ps1"; ## Load shlib.


##
## Load things!!!
##

##------------------------------------------------------------------------------
. "./path.ps1";            ## Setup our $PATH.
. "./pwsh_modules.ps1";    ## Load the Powershell modules.
. "./net.ps1";             ## Network utilities.
. "./prompt.ps1";          ## Customize our PS1.
. "./dots_function.ps1"    ## Make dots a function.
. "./shell_functions.ps1"; ## 
. "./version.ps1";         ## Show version and copyright.

## Load OS Dependent things...
if((sh_is_windows_or_wsl)) { 
    . "./win32.ps1"; 
}