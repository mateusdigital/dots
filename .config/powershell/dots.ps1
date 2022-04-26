##------------------------------------------------------------------------------

## Preset stuff...
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 0;

## Important directories
$CONFIG_DIR = "${HOME}/.config";
$BIN_DIR    = "${HOME}/.bin";
$PS_DIR     = "${CONFIG_DIR}/powershell";
$NVIM_DIR   = "${CONFIG_DIR}/nvim";
$SHLIB_DIR  = "${HOME}/.stdmatt/lib/shlib";

## Load shlib
if(-not (Test-Path "${SHLIB_DIR}/shlib.ps1")) {
    Remove-Item -Path "/var/tmp/shlib" -Force -Recurse;
    git clone "https://gitlab.com/stdmatt-libs/pwsh/shlib" "/var/tmp/shlib";
    & "/var/tmp/shlib/install.ps1";
}

. "${SHLIB_DIR}/shlib.ps1";

##
## dots
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
