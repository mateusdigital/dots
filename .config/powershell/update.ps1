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
    } else {
        sh_log "To implement.."
    }
}
