. "$HOME/.stdmatt/lib/rainbow/rainbow.ps1"
. "$HOME/.config/powershell/themes.ps1"

##
## Public Functions
##

##------------------------------------------------------------------------------
function global:prompt
{
    try {

        $history = (_make_history $LASTEXITCODE);
        # $git     = (_make_git);
        $path    = (_make_cwd);
        $os_name = (sh_get_os_name);

        return "${path} ${git} ${history}`n:) ";
    } catch {
        return ":) ";
    }
}

##------------------------------------------------------------------------------
function _make_cwd()
{
    $full_cwd = (Get-Location).Path;

    $cwd  = (sh_basepath $full_cwd);

    $icon = $PROMPT_THEME.cwd.icon;
    $fg   = $PROMPT_THEME.cwd.fg;
    $bg   = $PROMPT_THEME.cwd.bg;

    return (rbow "r[$fg,$bg]${icon}r[$fg,$bg] ${cwd}");
}

##------------------------------------------------------------------------------
function _make_history()
{
    $history = (Get-History);
    if(-not $history.Count) {
        return "";
    }

    $b = $PROMPT_THEME.status.bg;
    $last_history = $history[-1];

    ## CMD
    $cmd  = $last_history.CommandLine.Trim();

    $i = $PROMPT_THEME.status.cmd_icon;
    $f = $PROMPT_THEME.status.cmd_fg;

    $result = (rbow "r[$f,$b]$i" "(${cmd} ");

    ## Last Exit
    $last_exit = $args[0];

    $i = $PROMPT_THEME.status.last_exit_icon;
    $f = if($last_exit -eq 0) { $PROMPT_THEME.status.last_exit_fg_success }
         else                 { $PROMPT_THEME.status.last_exit_fg_failure }

    $result += (rbow "r[$f,$b]${i}${last_exit}");

    ## Duration
    $duration = $last_history.Duration.TotalMilliseconds;

    $i = $PROMPT_THEME.status.duration_icon;
    $f = if    ($duration -lt 100) { $PROMPT_THEME.status.duration_fg_fast   }
         elseif($duration -lt 500) { $PROMPT_THEME.status.duration_fg_medium }
         else                      { $PROMPT_THEME.status.duration_fg_slow   }

    $result += (rbow "r[$f,$b]${i}${duration}");

    ## Done...
    $result = $result.Trim() + ")";
    return $result;
}

##------------------------------------------------------------------------------
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
    $local_color = $null;
    if($local.Contains("feature/")) {
    }

    $bg = "#FF0000";
    $fg="$(pastel textcolor "$bg")"
    ## 
    $local_str = (pastel paint "$fg" --on "$bg" "well readable text") ;

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


. "$HOME/.stdmatt/lib/shlib/shlib.ps1"
. "$HOME/.config/powershell/git.ps1"

prompt;
