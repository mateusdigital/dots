##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

function help()
{
    ## @nimp(win32): Less is missing...
    Get-Help $args[0] | less;
}
