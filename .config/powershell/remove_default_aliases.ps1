## There's a bunch of aliases that Microsoft adds to the Powershell runtime 
## that's quite useful when you don't have the access to the coreutils tool.
## Moreover that aliases are not an 1:1 match to the original coreutils, which makes
## the behaviour acceptable on the command line - due the muscle memory - but 
## very troublesome to use in scripts. 
## We decided to use all the gnu coreutils tools in our scripts and tools in 
## all platforms. 
## This means that we need to unset a bunch of aliases here to make the things 
## works as intent, since alias seems to have precedence over the $PATH.
## 
## WARNING: 
##    THIS HAVE THE POSSIBILITY OF BREAK OTHER STUFF THAT *** WRONGLY *** 
##    DEPENDS ON THOSE ALIASES!!!!
##
## mmesquita - 22-08-29
##

Get-Alias | Where-Object { $_.Options -NE "Constant" } | Remove-Alias -Force;