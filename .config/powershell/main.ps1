##
## Environment Vars.
##

##------------------------------------------------------------------------------
$env:POWERSHELL_TELEMETRY_OPTOUT = 1; ## Don't track us.
$env:SHLIB_IS_VERSBOSE           = 0; ## We want a talkative shlib.

$DOTS_FORCE_INSTALL          = $false; ##


##
## Important directories
##

##------------------------------------------------------------------------------
$BIN_DIR    = "${HOME}/.bin";             ## The location of our custom binaries - It'll be 1st on PATH.
$LIB_DIR    = "${HOME}/.lib";             ## The location of our custom libraries. 
$CONFIG_DIR = "${HOME}/.config";          ## General configuration site.
$PS_DIR     = "${CONFIG_DIR}/powershell"; ## Powershell scripts site.
$SHLIB_DIR  = "${LIB_DIR}/shlib";         ## Location of shlib.
$TEMP_DIR   =  if($IsWindows) { $env:TEMP } else { "/tmp" };


##
## Ensure dependencies 
##

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
## Configure dots function
##

##------------------------------------------------------------------------------
function dots()
{
    ## @notice: [How dots are structure and mindset]
    ##
    ## We use a git bare repository with the work tree on $HOME.
    ## This means that with an addition of a custom gitignore 
    ## to avoid the noise, we can have all the files auto managed 
    ## by git itself, not needing for us to mess with syslinks and such.
    ##
    ## But in return we have a very long line to type everytime to make 
    ## git understand the repo's structure, even worse other tools doesn't 
    ## quite like the way that it's set by default (requiring a lot of typing as well.)
    ##
    ## So this function works as and entry point that actually makes the 
    ## needed hacks and forwards the maximum to the tools.
    ##
    ## For now we are just handling:
    ##   git, gitui

    $GIT_BARE_DIR = "${HOME/dots}";
    $GIT_WORK_DIR = "${HOME}";

    ## usage: dots gui -> Don't use the graphical one, but preserve the muscle memory.
    if($args.Length -eq 1 -and $args[0] -eq "gui") {
        gitui -d ${GIT_BARE_DIR} -w ${GIT_WORK_DIR};
    } 
    ## usage: dots <any-git-option> : It's still git!!
    ##        dots                  : We gonna use the alias:s as default when nothing is given.
    else {
        $args_ = (sh_value_or_default $args "s")
        git --git-dir=${GIT_BARE_DIR} --work-tree=${GIT_WORK_DIR} $args_;
    }
}

(dots config --local status.showUntrackedFiles no);                        ## Reduce noise.
(dots config --local core.excludesfile "${HOME}/.config/.dots_gitignore"); ## Custom gitignore.


##
## Load things!!!
##

##------------------------------------------------------------------------------
. "./net.ps1";
. "./path.ps1";
. "./prompt.ps1";
. "./pwsh_modules.ps1";
. "./shell.ps1";
. "./version.ps1";