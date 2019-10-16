##----------------------------------------------------------------------------##
##                       __      __                  __   __                  ##
##               .-----.|  |_.--|  |.--------.---.-.|  |_|  |_                ##
##               |__ --||   _|  _  ||        |  _  ||   _|   _|               ##
##               |_____||____|_____||__|__|__|___._||____|____|               ##
##                                                                            ##
##  File      : stdmatt_com.sh                                                ##
##  Project   : dots                                                          ##
##  Date      : Oct 17, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2019                                                ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##----------------------------------------------------------------------------##

## Reference:
##   https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client
##------------------------------------------------------------------------------
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
    sshfs "$STDMATT_COM_USER_AT_HOST:" "$STDMATT_COM_MOUNT_POINT"  \
        -ovolname="$STDMATT_COM_USER_AT_HOST"                       \
        -p 22                                                       \
        -o follow_symlinks                                       \
        -o idmap=user                                               \
        -C
}

##------------------------------------------------------------------------------
umount_stdmatt_com()
{
    umount "$STDMATT_COM_MOUNT_POINT";
    rm -rf "$STDMATT_COM_MOUNT_POINT";
}
