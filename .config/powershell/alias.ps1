
##
## Configure NVIM.
##

##------------------------------------------------------------------------------
$NVIM = if($IsWindows) { "nvim.exe" }  else { "nvim" }

$env:EDITOR = $NVIM;
$env:VISUAL = $NVIM;

##------------------------------------------------------------------------------
Set-Alias -Force -Option AllScope -Name vi  -Value $NVIM;
Set-Alias -Force -Option AllScope -Name vim -Value $NVIM;
Set-Alias -Force -Option AllScope -Name nv  -Value $NVIM;


##
## Single letter aliases.
##

##------------------------------------------------------------------------------
Set-Alias -Force -Option AllScope -Name "c" _stdmatt_cd; ## Change dir
Set-Alias -Force -Option AllScope -Name "f" files;       ## Files
Set-Alias -Force -Option AllScope -Name "l" _stdmatt_ls; ## List


##
## Single letter functions.
##

##------------------------------------------------------------------------------
function e()
{
    if($args.Count -eq 0) {
        & $NVIM ".";   ## Edit current path...
    } else {
        & $NVIM $args; ## Open with the given args...
    }
}

##------------------------------------------------------------------------------
function g()
{
    if($args.Length -eq 0) {
        git s;      ## git status by default.
    } else {
        git $args;  ## Just pass the args...
    }
}
