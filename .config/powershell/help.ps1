##------------------------------------------------------------------------------
function help()
{
    ## @nimp(win32): Less is missing...
    (Get-Help $args[0] | less);
    if(-not $?) {
        (man $args[0]);
        if(-not $?) {
            open "https://duckduckgo.com/?q=$value";
        }
    }
    echo "$LASTEXITCODE ::: $?"
}
