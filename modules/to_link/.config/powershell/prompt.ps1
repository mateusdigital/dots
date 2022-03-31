. "$HOME/.stdmatt/lib/rainbow/rainbow.ps1"
. "$HOME/.config/powershell/themes.ps1"

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
    $colored_cwd       = _make_cwd;
    $colored_git       = _make_git;
    $colored_status    = _make_history;
    $colored_separator = (rbow_colored $PROMPT_THEME.div.icon -fg $PROMPT_THEME.div.text_color);
    $colored_next_line = (rbow_colored $PROMPT_THEME.ps1.icon -fg $PROMPT_THEME.ps1.text_color);

    $p = (sh_join_string "$colored_separator" $colored_cwd $colored_git $colored_status);
    $p += "`n$colored_next_line";

    return $p;
}

function _make_cwd()
{
    $cwd_text = (Get-Location).Path;
    $cwd_icon = $PROMPT_THEME.cwd.icon;

    return (rbow2 `
        "<icon>${cwd_icon}<paren>(<text>${cwd_text}<paren>)" `
            -icon  $PROMPT_THEME.cwd.icon_color  `
            -paren $PROMPT_THEME.cwd.paren_color `
            -text  $PROMPT_THEME.cwd.text_color  `
    )
}

function _make_git()
{
    $git_result = (git status -sbu 2> /dev/null);
    if(-not $git_result) {
        return "";
    }

    ##
    ## Build info...
    ##

    ## @notice:(git -sbu info)
    ##   feature/Major-Restructure...origin/feature/Major-Restructure [ahead 3]

    ## Branch Names
    $line_comps = $git_result[0].Replace("]", "").Replace("[", "").Split(" ")[1..1000]
    $branches = $line_comps[0].Trim().Split("...");

    $local  = $branches[0].Trim();
    $remote = if($branches.Count -gt 1) { $branches[1].Trim() };

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
    ##
    $local_icon  = $PROMPT_THEME.git.local_icon;
    $add_icon    = $PROMPT_THEME.git.add_icon;
    $modify_icon = $PROMPT_THEME.git.modify_icon;
    $delete_icon = $PROMPT_THEME.git.delete_icon;
    $tag_icon    = $PROMPT_THEME.git.tag_icon;
    $ahead_icon  = $PROMPT_THEME.git.push_icon;
    $behind_icon = $PROMPT_THEME.git.pull_icon;
    $remote_icon = $PROMPT_THEME.git.remote_icon;

    return (rbow2 `
        "<local_icon>${local_icon}<p>(<t>${local} " `
        "<ai>${add_icon}<t>${A} <mi>${modify_icon}<t>${M} <di>${delete_icon}<t>${D}<p>) " `
        "<tag_icon>${tag_icon}<p>(<t>${tag}<p>) " `
        "<remote_icon>${remote_icon}<p>(<ahead_icon>${ahead_icon}${ahead} <behind_icon>${behind_icon}${behind}<p>)" `
        -p           $PROMPT_THEME.git.paren_color        `
        -t           $PROMPT_THEME.git.text_color         `
        -local_icon  $PROMPT_THEME.git.local_icon_color   `
        -ai          $PROMPT_THEME.git.add_icon_color     `
        -mi          $PROMPT_THEME.git.modify_icon_color  `
        -di          $PROMPT_THEME.git.delete_icon_color  `
        -tag_icon    $PROMPT_THEME.git.tag_icon_color     `
        -remote_icon $PROMPT_THEME.git.remote_icon_color  `
        -ahead_icon  $PROMPT_THEME.git.push_icon_color    `
        -behind_icon $PROMPT_THEME.git.pull_icon_color    `
    );
}

##------------------------------------------------------------------------------
function _make_history()
{
    $history = (Get-History);
    if(-not $history.Count) {
        return "";
    }

    $last_history = $history[-1];

    $cmd       = $last_history.CommandLine.Trim();
    $last_exit = (sh_value_or_default $args[0] 0);

    $icon  = $PROMPT_THEME.status.last_exit.icon;
    $color = if($last_exit -eq 0) { $PROMPT_THEME.status.last_exit.text_color_success }
             else                 { $PROMPT_THEME.status.last_exit.text_color_failure }

    $colored_exit = (rbow2 `
        "<color>${icon}<p>(<t>${last_exit}<p>)"  `
        -color $color                            `
        -p $PROMPT_THEME.status.paren_color      `
        -t $PROMPT_THEME.status.text_color       `
    );

    ## Duration
    $duration = $last_history.Duration.TotalMilliseconds;

    $icon  = $PROMPT_THEME.status.duration.icon;
    $color = if    ($duration -lt 100) { $PROMPT_THEME.status.duration.text_color_fast   }
             elseif($duration -lt 500) { $PROMPT_THEME.status.duration.text_color_medium }
             else                      { $PROMPT_THEME.status.duration.text_color_slow   }

    $colored_duration = (rbow2 `
        "<color>${icon}<p>(<t>${duration}<p>)"  `
        -color $color                            `
        -p $PROMPT_THEME.status.paren_color      `
        -t $PROMPT_THEME.status.text_color       `
    );

    return "$colored_exit $colored_duration"
}

. "$HOME/.stdmatt/lib/shlib/shlib.ps1"
. "$HOME/.config/powershell/git.ps1"

_make_prompt;
