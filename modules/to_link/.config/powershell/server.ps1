##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

##
## HTTP Server
##

##------------------------------------------------------------------------------
function http-server()
{
    (python3 -m http.server $args[1]) &;
}
