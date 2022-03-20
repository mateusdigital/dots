

##
## Private Things...
##

##------------------------------------------------------------------------------
function _get_default_PATH()
{
    if(-not $env:PATH_DEFAULT) {
        $env:PATH_DEFAULT = $env:PATH;
    }

    return $env:PATH_DEFAULT;
}

##------------------------------------------------------------------------------
function _configure_PATH()
{
    $paths_to_add = @();
    if($IsMacOS) {
        ## @notice(gnu-tools): Add all the gnu tools to the path
        ## so we can use them in mac without prefixing with g.
        $paths_to_add += @(
            "/usr/local/Cellar/coreutils/9.0_1/libexec/gnubin",
            "/usr/local/Cellar/ed/1.18/libexec/gnubin",
            "/usr/local/Cellar/findutils/4.9.0/libexec/gnubin",
            "/usr/local/Cellar/gawk/5.1.1/libexec/gnubin",
            "/usr/local/Cellar/gnu-sed/4.8/libexec/gnubin",
            "/usr/local/Cellar/gnu-tar/1.34/libexec/gnubin",
            "/usr/local/Cellar/grep/3.7/libexec/gnubin",
            "/usr/local/Cellar/libtool/2.4.6_4/libexec/gnubin",
            "/usr/local/Cellar/make/4.3/libexec/gnubin"
        );
    }
    else if($IsWindows) {

    }

    ## Paths that always will go...
    $paths_to_add += @(
        "/Users/stdmatt/.stdmatt/bin"
    );

    $default = $env:PATH_DEFAULT;
    $new     = (sh_join_string ":" $paths_to_add);

    return "${default}:${new}";
}

##
## Public Functions
##

##------------------------------------------------------------------------------
function list-path()
{
    foreach($item in ${env:PATH}.Split(":")) {
        sh_writeline $item;
    }
}

##
## Public Vars
##

##------------------------------------------------------------------------------
$env:PATH_DEFAULT = (_get_default_PATH);
$env:PATH         = (_configure_PATH);
