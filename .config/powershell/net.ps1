##
## HTTP Server
##

##------------------------------------------------------------------------------
function http-server()
{
    $port   = if($args.Length -gt 0) { $args[0]; } else { 8000 };
    $out_ip = (ifconfig | grep "inet 192").Trim().Split(" ")[1];

    while($true) {
        $has_connection = (Test-Connection -TargetName $out_ip -TcpPort $port);
        echo "ip: $out_ip - port: $port - connection: $has_connection";

        if(-not $has_connection) {
            sh_log "IP: ${out_ip}:${port}";

            python3 -m http.server $port;
            break;
        } else {
            $port += 1;
        }
    }
}

