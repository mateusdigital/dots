##
## Environment Vars.
##

##------------------------------------------------------------------------------
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 0;
$env:DOTS_FORCE_INSTALL          = 0;

##
## Important directories
##

##------------------------------------------------------------------------------
$BIN_DIR    = "${HOME}/.local/bin";

$CONFIG_DIR = "${HOME}/.config";
$PS_DIR     = "${CONFIG_DIR}/powershell";
$NVIM_DIR   = "${CONFIG_DIR}/nvim";

$LIB_DIR    = "${HOME}/.local/lib";
$SHLIB_DIR  = "${LIB_DIR}/shlib";

##
## Load shlib
##

##------------------------------------------------------------------------------
## If we don't have shlib, means that we are into a fresh install...
if((-not (Test-Path "${SHLIB_DIR}/shlib.ps1")) -or $env:DOTS_FORCE_INSTALL -ne 0) {
    echo "Installing shlib...";
        Remove-Item -Path "/var/tmp/shlib" -Force -Recurse;
        git clone "https://gitlab.com/stdmatt-libs/pwsh/shlib" "/var/tmp/shlib";
        & "/var/tmp/shlib/install.ps1";

    echo "Installing PSReadline...";
        Install-Module -Name PSReadLine;

    echo "Installing PSFzf...";
        git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
        $false | & "${HOME}/.fzf/install" --xdg;
        echo "Installing module...";
        Install-Module -Name PSFzf;
}

. "${SHLIB_DIR}/shlib.ps1";


##
## Configure dots function
##

##------------------------------------------------------------------------------
function dots()
{
    if($args.Length -eq 1 -and $args[0] -eq "gui") {
        gitui -d $HOME/.dots/ -w $HOME;
    } else {
        git --git-dir=$HOME/.dots/ --work-tree=$HOME $args;
    }
}

(dots config --local status.showUntrackedFiles no);
(dots config --local core.excludesfile "${HOME}/.config/.dots_gitignore");


##
## Load everything under the dots dir...
##

##------------------------------------------------------------------------------
foreach($item in (Get-ChildItem $PS_DIR)) {
    $name = $item.Name;

    if($name.StartsWith("_")) {
        continue;
    }

    ## Ignore all those files...
    if($name -eq "dots.ps1"                          -or `
       $name -eq "load_all.ps1"                      -or `
       $name -eq "_stratch.ps1"                      -or `
       $name -eq "Microsoft.PowerShell_profile.ps1"  -or `
       $name -eq "Microsoft.VSCode_profile.ps1")
    {
        continue;
    }

    sh_log_verbose "Loading file: $name";
    . $item.FullName;
}
