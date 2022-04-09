##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

##------------------------------------------------------------------------------
function g() { git $args; }

##
## Utils
##

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

##
## Repo
##

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

##
## Branch
##

##------------------------------------------------------------------------------
function git-get-branch-name()
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
function git-create-branch()
{
    $prefix   = $args[0];
    $values   = (sh_expand_array $args 1).ForEach({echo $_.Trim()});
    $name     = (sh_join_string "-" $values).Replace(" ", "-");
    $fullname = "${prefix}${name}";

    sh_writeline $fullname;
    git checkout -b $fullname;
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

##
## Submodules
##

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
function git-push-to-origin()
{
    $branch_name = (git-get-branch-name);

    if($branch_name -eq "") {
        sh_log_fatal "Invalid name...";
        return;
    }

    git push --set-upstream origin $branch_name;
}

##------------------------------------------------------------------------------
function git-new-bugfix()
{
    git-create-branch "bugfix/" $args;
}

##------------------------------------------------------------------------------
function git-new-feature()
{
    git-create-branch "feature/" $args;
}


##
## Clone
##

##------------------------------------------------------------------------------
function git-clone-full()
{
    $url = $args[0];
    git clone $url;

    $clean_name = (sh_basepath $url);
    if($clean_name.Contains(".git")) {
        $clean_name = $clean_name.Replace(".git", "");
    }

    sh_push_dir $clean_name;
        (git-update-submodule);
    sh_pop_dir;
}


##------------------------------------------------------------------------------
function git-clone-github()
{
    $url = $args[0].Trim();

    $repo      = (sh_basepath $url);
    $user      = (sh_basepath (sh_dirpath $url));
    $clone_url = "https://github.com/${user}/${repo}";
    $clone_dir = "${HOME}/Projects/github"; ## @todo: Bulletproof this path...

    sh_log "Cloning form: ${clone_url}";

    sh_mkdir $clone_dir;
    sh_push_dir $clone_dir;
        (git-clone-full $clone_url);
    sh_pop_dir;
}
