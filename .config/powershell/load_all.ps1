. "${HOME}/.config/powershell/dots.ps1";

## Load everything under the dots dir...
foreach($item in (Get-ChildItem $PS_DIR)) {
    $name = $item.Name;

    if($name.StartsWith("_")) {
        continue;
    }

    if($name -eq "load_all.ps1"                      -or `
       $name -eq "Microsoft.PowerShell_profile.ps1"  -or `
       $name -eq "Microsoft.VSCode_profile.ps1")
    {
        continue;
    }

    # sh_log_verbose "Loading: $name";
    . $item.FullName;
}
