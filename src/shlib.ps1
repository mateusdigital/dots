$SH_NEW_LINE     = "`n";

##------------------------------------------------------------------------------
function sh_join_string()
{
    $separator = $args[0];
    $values    = (sh_expand_array $args 1);

    return (Join-String -Separator $separator -InputObject $values);
}

##------------------------------------------------------------------------------
function sh_flatten_array()
{
    $values = $args.ForEach({$_});
    return $values;
}

##------------------------------------------------------------------------------
function sh_expand_array()
{
    $arr    = $args[0];
    $values = $arr.ForEach({$_});
    $start  = if($args.Length -gt 1) { $args[1]; } else { 0 }
    $end    = if($args.Length -gt 2) { $args[2]; } else { $values.Count }

    $values = $values[$start..$end];
    return $values;
}

##------------------------------------------------------------------------------
function sh_is_wsl()
{
    if($IsLinux) {
        $result = (uname -a);
        $index  = $result.IndexOf("WSL2");
        if($index -eq -1) {
            return $false;
        }
        return $true;
    }
    return $false;
}

##------------------------------------------------------------------------------
function _sh_fwd_slash()
{
    return $args[0].Replace("\", "/");
}



##------------------------------------------------------------------------------
$script:SH_ASK_CONFIRM_RESULT = $null;

function sh_ask_confirm()
{
    $script:SH_ASK_CONFIRM_RESULT = $null;

    writeline $args[0];
    $key = [Console]::ReadKey($true);
    $script:SH_ASK_CONFIRM_RESULT = ($key.Key -eq "Y");
}

##------------------------------------------------------------------------------
function sh_add_quotes()
{
    ## @improve: [Add single quotes] - 22-03-06
    ## if $args[1] is == "single" add single quotes...
    $value = $args[0];
    return "`"${value}`"";
}

##------------------------------------------------------------------------------
function sh_get_temp_filename()
{
    # $random    = (Get-Random);
    # $date_time = (sh_date_time_for_filenames $args);

    # return "${random}_$date_time";
    return [System.IO.Path]::GetTempFileName();
}

##------------------------------------------------------------------------------
function sh_date_time_for_filenames()
{
    $fmt = "%Y-%m-%d %H:%M:%S";
    if($args[0] -eq "safe") {
        $fmt = "%Y-%m-%d_%H-%M-%S";
    }

    $str = (Get-Date -UFormat $fmt);
    return $str;
}

##------------------------------------------------------------------------------
function sh_basepath()
{
    $arg = $args[0];
    $arg = $arg.Replace("\", "/");
    if ((_string_is_null_or_whitespace $arg)) {
        return "";
    }

    return $arg.Split("/")[-1];
}

##------------------------------------------------------------------------------
function sh_dirpath()
{
    $arg   = $args[0];
    $final = (Split-Path $arg -Parent);

    return $final;
}

##------------------------------------------------------------------------------
function sh_get_home_dir()
{
    if ($HOME -eq "") {
        return "$env:USERPROFILE"
    }

    return $HOME;
}

##------------------------------------------------------------------------------
function sh_get_os_name()
{
    if((sh_is_wsl)) {
        return "WSL";
    } elseif($IsWindows) {
        return "Win32";
    } elseif($IsLinux) {
        return "GNU";
    } elseif($IsMacOS) {
        return "mac";
    }
    return "unsupported";
}

##------------------------------------------------------------------------------
function sh_get_script_dir()
{
    return (sh_dirpath $MyInvocation.InvocationName);
}

##------------------------------------------------------------------------------
function sh_get_script_path()
{
    return $MyInvocation.PSCommandPath;
}

##------------------------------------------------------------------------------
function sh_file_exists()
{
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }
    return (Test-Path -Path $args[0] -PathType Leaf);
}

##------------------------------------------------------------------------------
function sh_dir_exists()
{
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }

    return (Test-Path -Path $args[0] -PathType Container);
}

##------------------------------------------------------------------------------
function sh_join_path()
{
    return [IO.Path]::Combine($args -split " ");
}

##------------------------------------------------------------------------------
function sh_mkdir()
{
    $path_to_create = $args[0];
    $null = (New-Item -ItemType directory -Path $path_to_create -Force);
}

##------------------------------------------------------------------------------
## Thanks to: Artem Tikhomirov - https://stackoverflow.com/a/422529
function sh_parse_ini_file($file)
{
    $ini = @{}

    # Create a default section if none exist in the file. Like a java prop file.
    $section = "NO_SECTION"
    $ini[$section] = [ordered]@{}
    try {
        switch -regex -file $file {
            "^\[(.+)\]$" {
                $section = $matches[1].Trim()
                $ini[$section] = [ordered]@{}
            }
            "^\s*([^#].+?)\s*=\s*(.*)" {
                $name, $value = $matches[1..2]
                # skip comments that start with semicolon:
                if (!($name.StartsWith(";"))) {
                    $ini[$section][$name] = $value.Trim()
                }
            }
        }
    } catch {
        return $null;
    }

    return $ini;
}

##------------------------------------------------------------------------------
function sh_print_ini($ini)
{
    $str = "";
    foreach($section_name in $ini.Keys) {
        $section = $ini[$section_name];
        if($section.Count -eq 0) {
            continue;
        }

        $str += "[$section_name]" + $SH_NEW_LINE;
        foreach($item_name in $section.Keys) {
            $item_value = $section[$item_name];
            $str += "   $item_name = $item_value".TrimEnd() + $SH_NEW_LINE;
        }
    }

    writeline $str;
}

##------------------------------------------------------------------------------
function sh_write_ini_to_file($ini, $filename)
{
    $str = (sh_print_ini $ini);
    (sh_write_file $filename $str);
}

## @todo(stdmatt): [Incomplete ini functions] at 22-03-06
##   - Add    value / section
##   - Modify value / section
##   - Create bare ini.
##------------------------------------------------------------------------------
function sh_ini_delete_section()
{
    $ini     = $args[0];
    $section = $args[1];
    $ini.Remove($section);
}

##------------------------------------------------------------------------------
function sh_ini_delete_value_on_section()
{
    $ini     = $args[0];
    $section = $args[1];
    $value   = $args[2];

    $ini[$section].Remove($value);
    return $ini;
}



##------------------------------------------------------------------------------
function sh_to_os_path()
{
    $path = $args[0];
    if($args.Length -eq 0) {
        return "";
    }

    $new_path              = $path;
    $looks_like_win32_path = ($path -match "([a-z]|[A-Z]):(\\|/)");
    if($looks_like_win32_path) {
        if((sh_is_wsl)) {
            $new_path = (wslpath -u $path);
        }
    } else {
        if($IsWindows) {
            $new_path = (wslpath -m $path);
        }
    }

    return $new_path;
}

##------------------------------------------------------------------------------
## Colors
$SH_HEX_RED   = "#FF0000";
$SH_HEX_GREEN = "#00FF00";
$SH_HEX_BLUE  = "#0000FF";

$SH_HEX_CYAN    = "#00FFFF";
$SH_HEX_YELLOW  = "#FFFF00";
$SH_HEX_MAGENTA = "#FF00FF";

$SH_HEX_BLACK      = "#000000";
$SH_HEX_GRAY       = "#808080";
$SH_HEX_LIGHT_GRAY = "#D4D4D3";
$SH_HEX_WHITE      = "#FFFFFF";

##------------------------------------------------------------------------------
function sh_rgb_to_ansi($r, $g, $b, $str)
{
    $esc = [char]27;
    return "$esc[38;2;$r;$g;${b}m$str$esc[0m";
}

##------------------------------------------------------------------------------
function sh_hex_to_ansi($hex, $str)
{
    if($hex.Length -ne 7) {
        $hex = "#FF00FF";
    }

    $esc = [char]27;
    $r = [uint32]("#" + $hex[1] + $hex[2]);
    $g = [uint32]("#" + $hex[3] + $hex[4]);
    $b = [uint32]("#" + $hex[5] + $hex[6]);

    return "$esc[38;2;$r;$g;${b}m$str$esc[0m";
}

##------------------------------------------------------------------------------
function sh_ansi($color, $str)
{
    ## @todo(stdmatt): Implement....
    return $str;
}

##------------------------------------------------------------------------------
function sh_write_file()
{
    $filename = $args[0];
    $content  = $args[1];

    Out-File -Filepath $filename -Encoding utf8 -Force -InputObject $content;
}
