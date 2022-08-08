##
## HTTP Server
##

##------------------------------------------------------------------------------
function http-server()
{
    ## @Notice: Here we are just grepping the output of ifconfig.
    ## I'm just assuming that we gonna have our external ip in the 192.xxx.xxx etc.
    ##      matt, 22-08-02
    $IFCONFIG_OUR_IP_PREFIX = "inet 192";

    $port   = if($args.Length -gt 0) { $args[0]; } else { 8000 };
    $out_ip = (ifconfig | grep "${IFCONFIG_OUR_IP_PREFIX}").Trim().Split(" ")[1];

    while($true) {
        $has_connection = (Test-Connection -TargetName $out_ip -TcpPort $port);
        echo "ip: $out_ip - port: $port - connection: $has_connection";

        if(-not $has_connection) {
            sh_log "IP: ${out_ip}:${port}";

            python3 -m http.server $port; ## @Improve: There's any reason to use a custom express server instead? matt - 22-08-02
            break;
        } else {
            $port += 1;
        }
    }
}

##------------------------------------------------------------------------------
function show-wifi-password() 
{
    $wifi_name = $args[0];
    netsh wlan show profile "${wifi_name}" key=clear;
}