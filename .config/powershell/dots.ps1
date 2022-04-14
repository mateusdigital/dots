
## Preset stuff...
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 0;


## Load shlib
$HOME_DIR = if ($HOME -eq "") { "$env:USERPROFILE" } else { $HOME };
. "${HOME_DIR}/.stdmatt/lib/shlib/shlib.ps1";


## Important directories
$CONFIG_DIR = "${HOME_DIR}/.config";
$BIN_DIR    = "${HOME_DIR}/.bin";
$PS_DIR     = "${CONFIG_DIR}/powershell";
$NVIM_DIR   = "${CONFIG_DIR}/nvim";


## Load everything under the dots dir...
foreach($item in (Get-ChildItem $PS_DIR)) {
    $name = $item.Name;
    if($name -eq "dots.ps1"                          -or `
       $name -eq "Microsoft.PowerShell_profile.ps1"  -or `
       $name -eq "Microsoft.VSCode_profile.ps1")
    {
        continue;
    }

    # sh_log_verbose "Loading: $name";
    . $item.FullName;
}


##
## dots
##

function dots()
{
    (/usr/bin/git --git-dir=$HOME_DIR/.dots/ --work-tree=$HOME_DIR $args);
}

(dots config --local status.showUntrackedFiles no);

