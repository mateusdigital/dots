##------------------------------------------------------------------------------
$NVIM = if($IsWindows) { "nvim.exe" }  else { "nvim" }

$env:EDITOR = $NVIM;
$env:VISUAL = $NVIM;

##
##
##

Set-Alias -Force -Option AllScope -Name "cd" -Value _stdmatt_cd;
Set-Alias -Force -Option AllScope -Name "ls" -Value _stdmatt_ls;
##------------------------------------------------------------------------------
Set-Alias -Force -Option AllScope -Name vi  -Value $NVIM;
Set-Alias -Force -Option AllScope -Name vim -Value $NVIM;
Set-Alias -Force -Option AllScope -Name nv  -Value $NVIM;

##
##
##

Set-Alias -Force -Option AllScope -Name "c" _stdmatt_cd; ## Change dir
Set-Alias -Force -Option AllScope -Name "e" $NVIM;       ## Edit
Set-Alias -Force -Option AllScope -Name "f" files;       ## Files
Set-Alias -Force -Option AllScope -Name "l" _stdmatt_ls; ## List


