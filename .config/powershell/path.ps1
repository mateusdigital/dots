## 
. "${HOME}/.lib/shlib/shlib.ps1";

##
## Private Things...
##

$OS_PATH_SEPARATOR = if($IsWindows) { ";" } else { ":" };

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
    $os_name   = "win32" ## (sh_get_os_name) @bug: sh_get_os_name should return win32
    $user_name = (sh_get_user_name);

    $paths_to_add = @(
        ## My stuff...
        "${HOME}/.bin",
        "${HOME}/.bin/dots",
        "${HOME}/.bin/dots/${os_name}"
    );

    ##--------------------------------------------------------------------------
    if($IsMacOS) {
        sh_log_verbose "Configuring path for macOS";
    }
    
    ##--------------------------------------------------------------------------
    elseif($IsLinux -or $sh_is_wsl) {
        sh_log_verbose "Configuring path for GNU/Linux";

        $paths_to_add += @(
            ## Anything first from powershell...
            "/usr/local/microsoft/powershell/7",
            ## Normal stuff...
            "/usr/local/bin", 
            "/usr/bin",
            "/usr/sbin",
            "/bin",
            "/sbin",
            ## VSCode...
            ##   @notice: For some reason VSCode is not found o pwsh inside bash.
            ##   So I'm adding it's path here... matt - 22-08-03
            "/mnt/c/Users/${user_name}/AppData/Local/Programs/Microsoft VS Code/bin/"
        );

        $new_path = (sh_join_string $OS_PATH_SEPARATOR $paths_to_add);
        $new_path += ${OS_PATH_SEPARATOR};
    }
    
    ##--------------------------------------------------------------------------
    elseif($IsWindows) {
        sh_log_verbose "Configuring path for Windows";
        
        $bin_dir = "$DOTS_BIN_DIR/dots/win32";
        
        $paths_to_add += @(
            "${bin_dir}/coreutils-5.3.0-bin/bin", 
            "${bin_dir}/findutils-4.2.20-2-bin/bin",
            "${bin_dir}/ProcessExplorer"
        );

        $new_path = (sh_join_string $OS_PATH_SEPARATOR $paths_to_add);
        $new_path += ${OS_PATH_SEPARATOR};
        
        $new_path += $env:PATH_DEFAULT; ## All the other windows things...
    }

    return "${new_path}${OS_PATH_SEPARATOR}";
}

##
## Public Functions
##

##------------------------------------------------------------------------------
function path-list()
{
    echo "Current PATH: "
    foreach($item in ${env:PATH}.Split($OS_PATH_SEPARATOR)) {
        sh_log "  $item";
    }
}


##
## Public Vars
##

##------------------------------------------------------------------------------
$env:PATH_DEFAULT = (_get_default_PATH);
$env:PATH         = (_configure_PATH  );

