. "$HOME/.stdmatt/lib/rainbow/rainbow.ps1"
. "$HOME/.config/powershell/themes.ps1"

$DT = $DEFAULT_THEME;
$PT = $PROMPT_THEME;

##
## Public Functions
##

##------------------------------------------------------------------------------
function global:prompt
{
    # return "$ "
    return _make_prompt
}

function _make_prompt()
{
    $status  = (_make_history $LASTEXITCODE);
    $git     = (_make_git);
    $cwd     = (_make_cwd);
    $os_name = (sh_get_os_name);

    $f = $PT.div.fg;
    $i = $PT.div.icon;
    $div = "r[$f]${i}";

    $line = (sh_join_string $div @($cwd, $git, $status));
    return (rbow "${line}`nr[$f]:) ");
}

##------------------------------------------------------------------------------
function _make_cwd()
{
    $full_cwd = (Get-Location).Path;

    $cwd  = $full_cwd; # (sh_basepath $full_cwd).Trim();

    $i = $PT.cwd.icon;
    $f = $PT.cwd.fg;
    return "r[$f]${i}r[]${cwd}";
}

##------------------------------------------------------------------------------
function _make_git()
{
    $git_result = ,(git status -sbu 2> /dev/null);
    if(-not $git_result) {
        return;
    }

    ##
    ## Build info...
    ##

    ## @notice:(git -sbu info)
    ##   feature/Major-Restructure...origin/feature/Major-Restructure [ahead 3]

    ## Branch Names
    $line_comps = $git_result[0].Replace("]", "").Replace("[", "").Split(" ")[1..1000]
    $branches = $line_comps[0].Trim().Split("...");

    $local    = $branches[0].Trim();
    $remote   = if($branches.Count -gt 1) { $branches[1].Trim() };

    ## Ahead / Behind
    $ahead  = 0;
    $behind = 0;

    for($i = 1; $i -lt $line_comps.Count; $i += 1) {
        $comp = $line_comps[$i];
        if($comp -eq "ahead") {
            $i += 1;
            $ahead = [int]$line_comps[$i];
        } elseif($comp -eq "behind") {
            $i += 1;
            $behind = [int]$line_comps[$i];
        }
    }

    ## Suno
    $A = 0; $D = 0; $M = 0; $U = 0;
    for($i = 1; $i -lt $git_result.Count; $i += 1) {
        $line = $git_result[$i].Trim();
        if($line[0] -eq "A") { $A += 1; }
        if($line[0] -eq "D") { $D += 1; }
        if($line[0] -eq "M") { $M += 1; }
        if($line[0] -eq "?") { $U += 1; }
    }

    $tag = (git describe --tags --abbrev=0);

    ##
    ## Color the things...
    ##

    ## Local Branch
    $i = $PT.git.icon;
    $f = $DT.normal.blue;
    $local = "r[$f]${i}r[](${local}";

    ## Status
    $i = $PT.git.add_icon;     $f = $DT.normal.green;  $A = "r[$f]${i}r[]${A}";
    $i = $PT.git.delete_icon;  $f = $DT.normal.red;    $D = "r[$f]${i}r[]${D}";
    $i = $PT.git.modify_icon;  $f = $DT.normal.yellow; $M = "r[$f]${i}r[]${M}";
    # $i = $PT.git.untrack_icon; $f = $DT.normal.white;  $U = "r[$f]${i}r[]${U}";
    $suno = "${A} ${M} ${D})";

    ## Tag
    $i = $PT.git.tag_icon;
    $f = "#CE9178";
    $tag = "r[$f]${i}r[](${tag})";

    ## Remote
    if($remote) {
        $i = $PT.git.remote_icon; $f = $DT.normal.cyan;  $remote = "r[$f]${i}r[]";
        $i = $PT.git.push_icon;   $f = $DT.normal.green; $ahead  = "r[$f]${i}r[]${ahead}";
        $i = $PT.git.pull_icon;   $f = $DT.normal.red;   $behind = "r[$f]${i}r[]${behind}";
        $remote = "${remote}(${ahead} ${behind})"
    }

    return "${local} $suno ${tag} ${remote}";
}


##------------------------------------------------------------------------------
function _make_history()
{
    $history = (Get-History);
    if(-not $history.Count) {
        return "";
    }

    $last_history = $history[-1];

    ## CMD
    $cmd  = $last_history.CommandLine.Trim();

    $i = $PT.status.cmd_icon;
    $f = $PT.status.cmd_fg;

    $cwd = "r[$f]${i}r[/](${cmd})";

    ## Last Exit
    $last_exit = $args[0];
    if($null -eq $last_exit) {
        $last_exit = 0;
    }

    $i = $PT.status.last_exit_icon;
    $f = if($last_exit -eq 0) { $PT.status.last_exit_fg_success }
         else                 { $PT.status.last_exit_fg_failure }

    $last_exit = "r[$f]${i}r[](${last_exit})";

    ## Duration
    $duration = $last_history.Duration.TotalMilliseconds;

    $i = $PT.status.duration_icon;
    $f = if    ($duration -lt 100) { $PT.status.duration_fg_fast   }
         elseif($duration -lt 500) { $PT.status.duration_fg_medium }
         else                      { $PT.status.duration_fg_slow   }

    $duration = "r[$f]${i}r[](${duration})";

    ## Done...
    return "${cwd} ${last_exit} ${duration}";
}

. "$HOME/.stdmatt/lib/shlib/shlib.ps1"
. "$HOME/.config/powershell/git.ps1"

_make_prompt;
