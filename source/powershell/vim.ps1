

## Remove-Alias -Path Alias:nv -Force -Option AllScope
$_nv = if($IsWindows) { "nvim.exe" }  else { "nvim" }

##------------------------------------------------------------------------------
Set-Alias -Name vi  -Value $_nv -Force -Option AllScope
Set-Alias -Name vim -Value $_nv -Force -Option AllScope
Set-Alias -Name nv  -Value $_nv -Force -Option AllScope

##------------------------------------------------------------------------------
$env:EDITOR = $_nv;
$env:VISUAL = $_nv;
