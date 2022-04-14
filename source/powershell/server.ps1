##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

##
## HTTP Server
##

##------------------------------------------------------------------------------
function http-server()
{
    $port = if($args.Length -gt 0) { $args[0]; }
    python3 -m http.server $port;
}
