##----------------------------------------------------------------------------##
## Network Ports                                                              ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
kill-port()
{
    test -z "$1"                                    \
        && pw_log_func "Port needs to be specified" \
        && return 1;

    npx kill-port $1;
}

##------------------------------------------------------------------------------
show-ports()
{
    ## @TODO(stdmatt): Check if works on linux...
    sudo lsof -iTCP -sTCP:LISTEN -n -P
}


##----------------------------------------------------------------------------##
## stdmatt.com                                                                ##
##----------------------------------------------------------------------------##
## Reference:
##   https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client
STDMATT_COM_USER_AT_HOST="stdmatt@stdmatt.com"
STDMATT_COM_MOUNT_POINT="$HOME/sshfs/$STDMATT_COM_USER_AT_HOST"

##------------------------------------------------------------------------------
mount_stdmatt_com()
{
    if [ -d "$STDMATT_COM_MOUNT_POINT" ]; then
        echo "[mount_stdmatt_com] Already has this mount point...";
        return;
    fi;

    mkdir -p "$STDMATT_COM_MOUNT_POINT";
    sshfs "$STDMATT_COM_USER_AT_HOST:" "$STDMATT_COM_MOUNT_POINT"   \
        -ovolname="$STDMATT_COM_USER_AT_HOST"                       \
        -p 22                                                       \
        -o follow_symlinks                                          \
        -o idmap=user                                               \
        -C
}

##------------------------------------------------------------------------------
umount_stdmatt_com()
{
    umount "$STDMATT_COM_MOUNT_POINT";
    rm -rf "$STDMATT_COM_MOUNT_POINT";
}


##---------------------------------------------------------------------------~##
## tinyurl.com                                                                ##
##---------------------------------------------------------------------------~##
##------------------------------------------------------------------------------
tinyurl()
{
    local url="$1";
    test -z "$url"                                   && \
        echo "[tinyurl] URL is required - Aborting." && \
        return 1;

    curl tinyurl.com/api-create.php?url="$url";
}


##---------------------------------------------------------------------------~##
## URL to PDF                                                                 ##
##---------------------------------------------------------------------------~##
##------------------------------------------------------------------------------
url-to-pdf()
{
    local URL="$1";
    local output_path="$(basename "$URL").pdf";

    ##
    ## Log info.
    echo "URL : ${URL}";
    echo "FILE: ${output_path}";
    echo "Downloading...";

    echo "import pdfkit; pdfkit.from_url(\"${URL}\", \"${output_path}\")" | python - > /dev/null
    echo "Done...";
}