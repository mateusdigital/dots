function g()
{
    if($args.Length -eq 0) {
        git s;
    } else {
        git $args;
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



##
## Clone
##

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
