##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))


##------------------------------------------------------------------------------
function update()
{
    if($IsMacOS) {
        (sudo softwareupdate -i -a);

        (brew update );
        (brew upgrade);
        (brew cleanup);

        (npm install npm -g);
        (npm update      -g);
    }
}
