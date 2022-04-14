
##------------------------------------------------------------------------------
$NVIM = if($IsWindows) { "nvim.exe" }  else { "nvim" }
$env:EDITOR = $NVIM;
$env:VISUAL = $NVIM;

##------------------------------------------------------------------------------
Set-Alias -Name vi  -Value $NVIM -Force -Option AllScope;
Set-Alias -Name vim -Value $NVIM -Force -Option AllScope;
Set-Alias -Name nv  -Value $NVIM -Force -Option AllScope;

## @XXX(Be Brave)!
## Set-Alias -Name code -Value $NVIM -Force -Option AllScope;


