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
        $paths_to_add += @(
            ## Anything first from powershell...
            "/usr/local/microsoft/powershell/7",
            ## @notice(gnu-tools): Add all the gnu tools to the path
            ## so we can use them in mac without prefixing with g.
            ##    find /usr/local/Cellar -iname "*gnubin" | sort
            "/usr/local/Cellar/coreutils/9.0_1/libexec/gnubin",
            "/usr/local/Cellar/ed/1.18/libexec/gnubin",
            "/usr/local/Cellar/findutils/4.9.0/libexec/gnubin",
            "/usr/local/Cellar/gawk/5.1.1/libexec/gnubin",
            "/usr/local/Cellar/gnu-sed/4.8/libexec/gnubin",
            "/usr/local/Cellar/gnu-tar/1.34/libexec/gnubin",
            "/usr/local/Cellar/grep/3.7/libexec/gnubin",
            "/usr/local/Cellar/libtool/2.4.6_4/libexec/gnubin",
            "/usr/local/Cellar/make/4.3/libexec/gnubin",
            ## Normal stuff...
            "/usr/local/bin", ## @notice(brew): Homebrew put it's stuff here...
            "/usr/bin",
            "/bin",
            "/usr/sbin",
            "/sbin",
            "/opt/X11/bin",
            ## My stuff...
            "/usr/local/opt/curl/bin",
            "/Users/stdmatt/.cargo/bin",
            "/Users/stdmatt/.stdmatt/bin"
        );
    }
    elseif($IsWindows) {

    }

    $default = $env:PATH_DEFAULT;
    $new     = (sh_join_string ":" $paths_to_add);
    return "${new}";
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
$env:PATH         = (_configure_PATH  );
