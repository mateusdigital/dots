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
    ##--------------------------------------------------------------------------
    if($IsMacOS) {
        sh_log_verbose "Configuring path for macOS";

        $paths_to_add += @(
            ## Anything first from powershell...
            "/usr/local/microsoft/powershell/7",
            ## @notice(gnu-tools): Add all the gnu tools to the path
            ## so we can use them in mac without prefixing with g.
            ##    find /usr/local/Cellar -iname "*gnubin" | sort

            ## This code is very wrong... It meant and work someday, but 
            ## we can be almost sure that those versions don't match anymore...
            ##      matt - 22-08-03
            # "/usr/local/Cellar/coreutils/9.0_1/libexec/gnubin",
            # "/usr/local/Cellar/ed/1.18/libexec/gnubin",
            # "/usr/local/Cellar/findutils/4.9.0/libexec/gnubin",
            # "/usr/local/Cellar/gawk/5.1.1/libexec/gnubin",
            # "/usr/local/Cellar/gnu-sed/4.8/libexec/gnubin",
            # "/usr/local/Cellar/gnu-tar/1.34/libexec/gnubin",
            # "/usr/local/Cellar/grep/3.7/libexec/gnubin",
            # "/usr/local/Cellar/libtool/2.4.6_4/libexec/gnubin",
            # "/usr/local/Cellar/make/4.3/libexec/gnubin",
            ## Normal stuff...
            "/usr/local/bin", ## @notice(brew): Homebrew put it's stuff here...
            "/usr/bin",
            "/usr/sbin",
            "/bin",
            "/sbin",
            "/opt/X11/bin",
            "/usr/local/opt/curl/bin",
            ## My stuff...
            "${HOME}/.local/bin",
            "${HOME}/.fzf/bin",
            "${HOME}/.cargo/bin"
        );
    }
    ##--------------------------------------------------------------------------
    elseif($IsLinux -or $sh_is_wsl) {
        sh_log_verbose "Configuring path for GNU/Linux";
        $user_name = (sh_get_user_name);
        
        $paths_to_add += @(
            ## My stuff...
            "${HOME}/.bin",
            "${HOME}/.bin/dots",
            "${HOME}/.bin/dots/gnu",
            
            "${HOME}/.fzf/bin",
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
    }
    elseif($IsWindows) {
        sh_log_verbose "Configuring path for Windows";
    }

    $new_path = (sh_join_string ":" $paths_to_add);
    return "${new_path}";
}

##
## Public Functions
##

##------------------------------------------------------------------------------
function path-list()
{
    foreach($item in ${env:PATH}.Split(":")) {
        sh_log $item;
    }
}


##
## Public Vars
##

##------------------------------------------------------------------------------
$env:PATH_DEFAULT = (_get_default_PATH);
$env:PATH         = (_configure_PATH  );

if($env:DOTS_IS_VERSBOSE -eq 1) { 
    path-list;
}