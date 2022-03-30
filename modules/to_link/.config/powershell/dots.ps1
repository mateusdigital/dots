
## Preset stuff...
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 1;

## Load shlib
. "${HOME}/.stdmatt/lib/shlib/shlib.ps1"; ## @todo: Bulletproof this path...


## Load everything under the dots dir...
$DOTS = (sh_get_script_dir);
foreach($item in (Get-ChildItem $DOTS)) {
    $name = $item.Name;
    if($name -eq "dots.ps1"                          -or `
       $name -eq "Microsoft.PowerShell_profile.ps1"  -or `
       $name -eq "Microsoft.VSCode_profile.ps1")
    {
        continue;
    }

    sh_log_verbose "Loading: $name";
    . $item.FullName;
}
