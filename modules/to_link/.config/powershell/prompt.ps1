
##
## Public Functions
##

##------------------------------------------------------------------------------
function global:prompt
{
   return _make_prompt;
}
$FG = "#FFFFFF";
$BG = "#007ACC";
$BG = "#6A9955"
##
## Private Functions
##

##------------------------------------------------------------------------------
function _make_prompt()
{
    $history = (_make_history_status $LASTEXITCODE);
    $git     = (_make_git);
    $path    = (_make_path);
    $os_name      = (sh_get_os_name);

    return "${path} ${git} ${history}`n:) ";
}

function _make_path()
{
    $cwd = (Get-Location).Path;
    $cwd = (sh_basepath $cwd)

    return (sh_ansi_hex_color " $cwd" $FG $BG);
}

function _make_history_status()
{
    $history = (Get-History);
    if(-not $history.Count) {
        return "";
    }

    $last_history = $history[-1];

    $cmd       = $last_history.CommandLine.Trim();
    $last_exit = $args[0];
    $duration  = $last_history.Duration.TotalMilliseconds;

    $result = " (${cmd} ";
    if($last_exit) { $result += " ${last_exit}"; }
    if($duration ) { $result += "  ${duration}";  }
    $result = $result.Trim() + ")";

    return (sh_ansi_hex_color "$result" $FG $BG);
}

function _make_git()
{
    $git_result = (git status -sb 2> /dev/null);
    if(-not $?) {
        return;
    }

    $names  = $git_result[0].Replace("#", "").Replace("...", ";").Split(";");
    $local  = $names[0].Trim();
    $remote = $names[1].Trim();

    ##
    ## Branch
    ##

    $local_str = " $local";

    ##
    ## Collect status info
    ##

    $suno = "";

    $A = 0; $M = 0; $D = 0;
    foreach($line in (git status -suno)) {
        $line = $line.Trim();
        if($line[0] -eq "A") { $A += 1; }
        if($line[0] -eq "M") { $M += 1; }
        if($line[0] -eq "D") { $D += 1; }
    }

    $suno += if($A -or $true) { "都${A} " };
    $suno += if($M -or $true) { " ${M} " };
    $suno += if($D -or $true) { "逸${D} " };

    $suno = $suno.Trim();

    ##
    ## Ahead / Behind
    ##

    $ahead_behind = "";
    if($remote) {
        $git_result = (git rev-list --left-right --count ${local}...${remote});
        if($?) {
            $split  =  $git_result.Split("`t");
            $ahead  = $split[0];
            $behind = $split[1];

            $ahead_behind = "摒 $ahead/$behind";
        }
    }

    ##
    ## Tags
    ##
    $tag  = (git describe --tags (git rev-list --tags --max-count=1) 2> $null);

    $result = "${local_str} ${suno} ${ahead_behind}"
    return (sh_ansi_hex_color "$result" $FG $BG);
}


# . "$HOME/.stdmatt/lib/shlib/shlib.ps1"
# . "$HOME/.config/powershell/git.ps1"

# _make_prompt
