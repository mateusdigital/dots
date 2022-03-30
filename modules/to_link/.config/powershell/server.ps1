
##
## HTTP Server
##

##------------------------------------------------------------------------------
function http-server()
{
    (python3 -m http.server $args[1]) &;
}

