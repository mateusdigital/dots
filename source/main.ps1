##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
. "${HOME}/.stdmatt/lib/shlib/shlib.ps1";

##------------------------------------------------------------------------------
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 1;


##----------------------------------------------------------------------------##
## Info                                                                       ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
$PROGRAM_NAME            = "dots";
$PROGRAM_VERSION         = "3.0.0";
$PROGRAM_AUTHOR          = "stdmatt - <stdmatt@pixelwizads.io>";
$PROGRAM_COPYRIGHT_OWNER = "stdmatt";
$PROGRAM_COPYRIGHT_YEARS = "2021, 2022";
$PROGRAM_DATE            = "30 Nov, 2021";
$PROGRAM_LICENSE         = "GPLv3";


##----------------------------------------------------------------------------##
## PSReadLine                                                                 ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _configure_PSReadLine()
{
    $_ps_color_black         = "#1E1E1E";  ##
    $_ps_color_gray          = "#808080";  ## #include
    $_ps_color_white         = "#D4D4D4";  ## normal text
    $_ps_color_light_blue    = "#9CDCFE";  ## my_variable
    $_ps_color_blue          = "#569CD6";  ## public static void
    $_ps_color_blue_green    = "#4EC9B0";  ## Class_Type
    $_ps_color_green         = "#608B4E";  ## /* comment */
    $_ps_color_light_yellow  = "#B5CEA8";  ## 3.14f
    $_ps_color_yellow        = "#DCDCAA";  ## my_function()
    $_ps_color_yellow_orange = "#D7BA7D";  ## #selector
    $_ps_color_orange        = "#CE9178";  ## "string"
    $_ps_color_light_red     = "#D16969";  ## /[a-Z]/
    $_ps_color_red           = "#F44747";  ## error message
    $_ps_color_pink          = "#C586C0";  ## else if

    Set-PSReadLineOption                                  `
        -ViModeIndicator     Script                       `
        -ViModeChangeHandler $Function:_on_vi_mode_change `
        -EditMode            Vi                           `
        -PredictionSource    History                      `
        -Colors              @{
            Default            = $_ps_color_white
            Comment            = $_ps_color_green
            Command            = $_ps_color_yellow
            Keyword            = $_ps_color_pink
            ContinuationPrompt = "#FF00FF"
            Number             = $_ps_color_light_yellow
            Member             = $_ps_color_white
            Operator           = $_ps_color_white
            Type               = $_ps_color_light_blue
            Parameter          = $_ps_color_pink
            String             = $_ps_color_orange
            Variable           = $_ps_color_light_blue
        }
}

##------------------------------------------------------------------------------
function _on_vi_mode_change
{
    if ($args[0] -eq 'Command') {
        Write-Host -NoNewLine "`e[1 q";
    } else {
        Write-Host -NoNewLine "`e[5 q";
    }
}


##----------------------------------------------------------------------------##
## PATH                                                                       ##
##----------------------------------------------------------------------------##
##----------------------------------------------------------------------------##
function _configure_PATH()
{
    if($IsMacOS) {
        $paths = @(
            "/usr/local/opt/coreutils/libexec/gnubin",
            "/usr/local/opt/gnu-tar/libexec/gnubin",
            "/usr/local/opt/ed/libexec/gnubin",
            "/usr/local/opt/grep/libexec/gnubin",
            "/usr/local/opt/gnu-sed/libexec/gnubin",
            "/usr/local/opt/gsed/libexec/gnubin",
            "/usr/local/opt/gawk/libexec/gnubin",
            "/usr/local/opt/make/libexec/gnubin",
            "/usr/local/opt/findutils/libexec/gnubin"
        )

        $env:PATH = $env:PATH + ":" + (sh_join_string ":" $paths);
    }

    $env:PATH = $env:PATH + ":" + "/Users/stdmatt/.stdmatt/bin";
}

##------------------------------------------------------------------------------
function show_version()
{
    $value = [string]::Format(
"{0} - {1} - {2}                                      `
Copyright (c) {3} - {4}                               `
This is a free software ({5}) - Share/Hack it         `
Check http://stdmatt.com for more :)",
        $PROGRAM_NAME,
        $PROGRAM_VERSION,
        $PROGRAM_AUTHOR,
        $PROGRAM_COPYRIGHT_YEARS,
        $PROGRAM_COPYRIGHT_OWNER,
        $PROGRAM_LICENSE
    );

    sh_writeline $value;
}


##----------------------------------------------------------------------------##
## Journal                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function journal()
{
    $JOURNAL_DIR       = "$HOME_DIR/Desktop/Journal";
    $JOURNAL_GIT_URL   = "https://gitlab.com/stdmatt-private/journal";
    $JOURNAL_FILE_EXT = ".info";

    ## @todo(stdmatt): Would be nice to actually make the function to write
    ## the header automatically with the start and end dates of the week - 3/15/2021, 10:27:14 AM
    $cultureInfo = [System.Globalization.CultureInfo]::CurrentCulture;
    $week_day    = $cultureInfo.Calendar.GetWeekOfYear(
        (Get-Date),
        $cultureInfo.DateTimeFormat.CalendarWeekRule,
        $cultureInfo.DateTimeFormat.FirstDayOfWeek
    )

    ## This creates a new file with the date as filename if it doesn't exists...
    $curr_date_str    = "week_" + $week_day;
    $journal_filename = "$JOURNAL_DIR" + "/" + $curr_date_str + $JOURNAL_FILE_EXT;

    try {
        (sh_mkdir $JOURNAL_DIR);
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    _stdmatt_cd $JOURNAL_DIR;
    nvim .
    _stdmatt_cd "-";
}

##------------------------------------------------------------------------------
function sync-journal()
{
    if(!(sh_dir_exists $JOURNAL_DIR)) {
        git clone "https://gitlab.com/stdmatt-private/journal" "$JOURNAL_DIR";
        return;
    }

    cd $JOURNAL_DIR;
    git add .

    $current_pc_name = hostname;
    $current_date    = date;
    $commit_msg      = "[sync-journal] ($current_pc_name) - ($current_date)";

    sh_log $commit_msg;
    git commit -m "$commit_msg";

    git pull
    git push
}


##----------------------------------------------------------------------------##
## Git                                                                        ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function g()
{
    git $args;
}

##------------------------------------------------------------------------------
function git-config()
{
    sh_log_verbose "Configuring git...";
    ## Info...
    git config --global user.name  "stdmatt";
    git config --global user.email "stdmatt@pixelwizards.io";

    ## Normal stuff...
    git config --global core.excludesfile "~/.gitignore";            ## Set the gitignore globaly...
    git config --global core.editor       "nvim";                    ## Set nvim as default editor...
    git config --global core.autocrlf     false;
    git config --global core.filemode     false;

    git config --global init.defaultBranch "main";

    ## Aliases...
    git config --global alias.c commit;
    git config --global alias.s status;
    git config --global alias.d diff  ;

    sh_log_verbose "Done... ;D";
}

##------------------------------------------------------------------------------
function git-first-date-of()
{
    $filename = $args[0];
    if(-not (sh_file_exists($filename))) {
        sh_log_fatal "Missing ($filename)";
        return;
    }

    $date_format = "%d %b, %Y";
    $lines       = (git log --diff-filter=A --follow --format=%ad  --date=format:$date_format --reverse -- "${filename}");
    sh_writeline $lines;
}

##------------------------------------------------------------------------------
function git-get-repo-url()
{
    $remote = (git remote -v); # | head -1 | expand -t1 | cut -d" " -f2;
    if($remote.GetType().Name -eq "Object[]") {
        $remote = $remote[0]
    }

    $components = $remote.Replace("`t", " ").Split(" ");
    $url        = $components[1];

    sh_writeline $url;
}

##------------------------------------------------------------------------------
function git-get-repo-root()
{
    ## @improve: make the git error not in the output...
    $result = (git rev-parse --show-toplevel);
    return $result;
}


##------------------------------------------------------------------------------
function git-curr-branch-name()
{
    $result = (git branch);
    foreach($item in $result) {
        $name = $item.Trim();
        if($name.StartsWith("*")) {
            $clean_name = $name.Replace("*", "").Trim();
            return $clean_name;
        }
    }
    return "";
}

##------------------------------------------------------------------------------
function git-delete-branch()
{
    $branch_name = $args[0];
    $grep_result = (git branch --all | grep $branch_name);

    if($grep_result.Length -eq 0) {
        sh_log_fatal "Invalid branch ($branch_name)";
        return;
    }

    sh_log "Deleting branch: ($branch_name)";
    git branch      --delete $branch_name;
    git push origin --delete $branch_name;

    sh_log "Deleted...";
}

##------------------------------------------------------------------------------
function git-push-to-origin()
{
    $branch_name = (git-curr-branch-name);
    if($branch_name -eq "") {
        sh_log_fatal "Invalid name...";
        return;
    }

    git push --set-upstream origin $branch_name;
}

##------------------------------------------------------------------------------
function git-get-submodules()
{
    $result = (git submodule status);
    foreach($item in $result) {
        $comps = $item.Split();
        sh_writeline $comps[2];
    }
}

##------------------------------------------------------------------------------
## Thanks to: John Douthat - https://stackoverflow.com/a/1260982
function git-remove-submodule()
{
    $repo_root = (git-get-repo-root);
    if($repo_root -eq $null) {
        sh_log_fatal "Not in a git repo...";
        return $false;
    }

    $submodule_name   = $args[0];
    $submodules_names = (git-get-submodules);
    $is_valid         = $submodules_names.Contains($submodule_name);

    if(-not $is_valid) {
        sh_log_fatal "Invalid submodule name ${submodule_name}";
        return;
    }

    $quoted_name = (sh_add_quotes $submodule_name);

    ## @improve: [Creating to much files...] at 22-03-06, 17:44
    ##   Creating this amount of files just to make the diff works.
    ##   Make a way to the ini file to be stable (read order) that
    ##   it would not be needed...
    ##   - Here in Brazil, at mom's house with my Mariia, my wife, our baby
    ##     waiting to grow, super hot weather and pingo!
    ##     Super sad with what's happening at our home ukraine :`(
    $modules_filename = "${repo_root}/.gitmodules";
    $config_filename  = "${repo_root}/.git/config";
    $modules_ini      = (sh_parse_ini_file $modules_filename);
    $config_ini       = (sh_parse_ini_file $config_filename);

    $modules_temp_input  = (sh_get_temp_filename "safe");
    $modules_temp_output = (sh_get_temp_filename "safe");
    $config_temp_input   = (sh_get_temp_filename "safe");
    $config_temp_output  = (sh_get_temp_filename "safe");

    sh_log "Removing submodule: ${submodule_name}";

    ##
    ## Change the entry in modules.
    ##
    sh_write_ini_to_file  $modules_ini $modules_temp_input;
    sh_ini_delete_section $modules_ini "submodule ${quoted_name}";
    sh_write_ini_to_file  $modules_ini $modules_temp_output;

    _git_remove_submodule_diff $modules_temp_input $modules_temp_output;

    ##
    ## Change the entyr in config.
    ##
    sh_write_ini_to_file  $config_ini $config_temp_input;
    sh_ini_delete_section $config_ini "submodule ${quoted_name}";
    sh_write_ini_to_file  $config_ini $config_temp_output;

    _git_remove_submodule_diff $config_temp_input $config_temp_output;

    ##
    ## Make sure that things looks fine...
    ##

    ## Delete the relevant section from the .gitmodules file.
    sh_write_ini_to_file $modules_ini $modules_filename;
    ## Stage the .gitmodules changes git add .gitmodules
    git add $modules_filename;
    ## Delete the relevant section from .git/config.
    sh_write_ini_to_file $config_ini $config_filename;
    ## Run git rm --cached path_to_submodule (no trailing slash).
    git rm --cached $submodule_name;
    ## Run rm -rf .git/modules/path_to_submodule
    nuke-dir ".git/modules/${submodule_name}";
    ## Commit git commit -m "Removed submodule <name>"
    git commit -m "[REMOVE-SUBMODULE] ${submodule_name}";
    ## Delete the now untracked submodule files
    ## rm -rf path_to_submodule
    nuke-dir $submodule_name;
}

##------------------------------------------------------------------------------
function _git_remove_submodule_diff()
{
    $file_a = $args[0];
    $file_b = $args[1];

    diff --color                `
         --text                 `
         --ignore-case          `
         --ignore-tab-expansion `
         --ignore-space-change  `
         --ignore-all-space     `
         --ignore-blank-lines   `
         --strip-trailing-cr    `
         --side-by-side         `
        $file_a                 `
        $file_b;
}

##------------------------------------------------------------------------------
function git-update-submodule()
{
    git submodule update --init --recursive;
}

##
## New Branch
##
##------------------------------------------------------------------------------
function git-new-branch()
{
    $prefix = $args[0];
    $values = (sh_expand_array $args 1).ForEach({echo $_.Trim()});
    $name   = (sh_join_string "-" $values).Replace(" ", "-");
    sh_writeline "${prefix}${name}";

    git checkout -b $name;
}

##------------------------------------------------------------------------------
function git-new-bugfix()
{
    git-new-branch "bugfix/" $args;
}

##------------------------------------------------------------------------------
function git-new-feature()
{
    git-new-branch "feature/" $args;
}


##------------------------------------------------------------------------------
function git-clone-full()
{
    $url = $args[0];
    git clone $url;

    $clean_name = (sh_basepath $arg).Remove(".git");
    cd $clean_name;

    git-update-submodule;
}


##----------------------------------------------------------------------------##
## Shell                                                                      ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _make_git_prompt()
{
    $git_line = (git branch 2> $null);
    if($git_line) {
        if($git_line -is [array]) {
            for($i = 0; $i -lt $git_line.Length; $i += 1) {
                $str = $git_line[$i].Trim();
                if($str.StartsWith("*")) {
                    $git_line = $str;
                    break;
                }
            }
        }
        $git_branch = $git_line.Trim().Substring(2, $git_line.Length-2);

        ## @todo(stdmatt): 30 Nov, 2021 at 12:40:48
        ## Check how we want the PS1 to display git info...
        # $user_name  = (git config user.name);
        # $user_email = (git config user.email);
        $git_tag    = (git describe --tags (git rev-list --tags --max-count=1) 2> $null);

        if($git_tag) {
            $git_line = "${git_branch}-${git_tag}";
        } else {
            $git_line = "${git_branch}";
        }

        $git_line = ":[$git_line]";
    }

    $curr_path    = (Get-Location).Path;
    $prompt       = ":)";
    $os_name      = (sh_get_os_name);
    $hash         = (echo $curr_path | md5);

    $colored_os_name  = (sh_ansi_color    ":[${os_name}]" $SH_ANSI_BRIGHT_BLACK_FG);
    $colored_git_line = (sh_ansi_color     "${git_line}"  $SH_ANSI_BRIGHT_BLACK_FG);
    $colored_prompt   = (sh_ansi_hex_color "$prompt"      "9E9E9E");
    $colored_path     = (sh_ansi_hex_color  $curr_path $hash[2..7]);

    $output = "${colored_path}${colored_os_name}${colored_git_line}`n${colored_prompt} ";

    return $output;
}

##------------------------------------------------------------------------------
function global:prompt
{
    return _make_git_prompt;
}


##----------------------------------------------------------------------------##
## Aliases / Commands                                                         ##
##----------------------------------------------------------------------------##


##
## cd
##

$global:OLDPWD="";
function _stdmatt_cd()
{
    ## @notice(stdmatt): This is pretty cool - It makes the cd to behave like
    ## the bash one that i can cd - and it goes to the OLDPWD.
    ## I mean, this thing is neat, probably PS has some sort of this like that
    ## but honestly, not in the kinda mood to start to look to all the crap
    ## microsoft documentation. But had quite fun time doing this silly thing!
    ## Kinda the first thing that I write in my standing desk here in kyiv.
    ## I mean, this is pretty cool, just could imagine when I get my new keychron!
    ## March 12, 2021!!


    $target_path = $args[0];
    if($target_path -eq "") {
        $target_path = "$HOME_DIR";
    }
    if($target_path -eq "-") {
        $target_path=$global:OLDPWD;
    }

    $global:OLDPWD =  [string](Get-Location);
    Set-Location $target_path; ## Needs to be the Powershell builtin or infinity recursion
}

##------------------------------------------------------------------------------
Remove-Item -Path Alias:cd
Set-Alias -Name cd -Value _stdmatt_cd -Force -Option AllScope


##
## Files
##

##------------------------------------------------------------------------------
function files()
{
    ## Open the Filesystem Manager into a given path.
    ## If no path was given open the current dir.
    $target_path = $args[0];
    if ($target_path -eq "") {
        $target_path=".";
    }

    $file_manager = (_host_get_file_manager);
    if($file_manager -eq "") {
        sh_log_fatal("No file manager was found - Aborting...");
        return;
    }

    if(-not (sh_dir_exists $target_path)) {
        sh_log_fatal("Invalid path - Aborting...");
        return;
    }

    & $file_manager $target_path;
    return;
}

##------------------------------------------------------------------------------
function _host_get_file_manager()
{
    if($IsWindows -or (sh_is_wsl)) {
        return "explorer.exe";
    } elseif($IsMacOS) {
        return "open";
    }

    ## @todo(stdmatt): Add for linux someday... at 2022-03-04, 15:54
    return "";
}


##
## Make Link
##

##------------------------------------------------------------------------------
function make-link()
{
    $src_path = $args[0];
    $dst_path = $args[1];

    if (-not $src_path) {
        sh_log_fatal("Missing source path - Aborting...");
        return;
    }

    if((sh_is_unix_like)) {
        ln $src_path $dst_path;
    } else {
        ## @todo(stdmatt): Should we check errors???
        $null = (New-Item -ItemType HardLink -Target $src_path -Path $dst_path -Force);
    }
}


##
## Vim
##

##------------------------------------------------------------------------------
## Remove-Alias -Path Alias:nv -Force -Option AllScope
$_nv = if($IsWindows) { "nvim.exe" }  else { "nvim" }

Set-Alias -Name vi  -Value $_nv -Force -Option AllScope
Set-Alias -Name vim -Value $_nv -Force -Option AllScope
Set-Alias -Name nv  -Value $_nv -Force -Option AllScope

$env:EDITOR = $_nv;
$env:VISUAL = $_nv;


##
## kill
##

##------------------------------------------------------------------------------
function kill-process()
{
    $process_name = $args[0];
    $line         = (ps | grep $process_name);

    if($line.Length -eq 0) {
        sh_log_fatal "No process with name: (${process_name})";
        return;
    } elseif($line.Length -gt 1 -and $line.GetType().FullName -ne "System.String") {
        ## @todo(stdmatt): [Pretty Print] 09 Dec, 2021 at 00:58:30
        ## Print each process in a different line.
        sh_log_fatal "More than one process were found: (`n${line}`n)";
        return;
    }

    $comps_dirty = $line.Split(" ");
    $comps_clean = @();

    for($i = 0; $i -lt $comps_dirty.Length; $i += 1) {
        $comp = $comps_dirty[$i];
        if($comp.Length -eq 0) {
            continue;
        }
        $comps_clean += $comp;
    }

    $PROCESS_ID_INDEX_IN_PS_OUTPUT = 4;
    $process_id                    = $comps_clean[$PROCESS_ID_INDEX_IN_PS_OUTPUT];

    sh_log "Killing proccess: ($process_name id: ${process_id})";
    kill $process_id -Force
}

##------------------------------------------------------------------------------
function kill-for-anvil()
{
    kill-process guild
    kill-process hoard
    kill-process Phoenix.Module
    kill-process Phoenix.Studio
}

##
## Delete (rm)
##

##------------------------------------------------------------------------------
function nuke-dir()
{
    ## @improve(stdmatt): [Handle multiple args]
    $path_to_remove = $args[0];
    if($path_to_remove -eq "") {
        sh_log_fatal "No directory path was given";
        return;
    }

    $dir_is_valid = (sh_dir_exists $path_to_remove);
    if(-not $dir_is_valid) {
        sh_log_fatal "Path isn't a valid directory...";
        return;
    }

    if($IsWindows) {
        rm -Recurse -Force $path_to_remove;
    } else {
        rm -rf "$path_to_remove";
    }
}


##
## HTTP Server
##

##------------------------------------------------------------------------------
function http-server()
{
    python3 -m http.server $args[1];
}




##----------------------------------------------------------------------------##
## Entry Point 								      ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_configure_PATH
_configure_PSReadLine

$shlib = "$HOME/.stdmatt/lib/shlib/shlib.ps1"
$dots  = (sh_get_script_dir);

#####################
## Nice to pipe stuff and calculate things....
# PS> $ageList.values | Measure-Object -Average
# Count   : 2
# Average : 22.5
