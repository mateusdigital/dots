##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/stdmatt/shellscript_utils/main.sh


##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
_dots_bench()
{
    local ITERATIONS="$1";
    local PROG="$2";
    local SIZE=$(pw_strlen "$ITERATIONS");
    local CMD="$@";
    local ARGS=$(pw_substr "$CMD" $SIZE)

    ## echo "ITERATIONS $ITERATIONS";
    ## echo "SIZE       $SIZE";
    ## echo "CMD        $CMD";
    ## echo "ARGS       $ARGS";
    for i in $(seq 1 $ITERATIONS); do
        $ARGS;
    done;
}

bench()
{
    time _dots_bench $@
}