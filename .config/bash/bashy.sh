test $BASHY_SH_LOADED && return;
BASHY_SH_LOADED=1;

bashy_Platform=$(uname);
bashy_IsGNU=$(test $bashy_Platform == "Linux" && echo "1");
bashy_IsMacOS=$(test $bashy_Platform == "Darwin" && echo "1");


## https://stackoverflow.com/a/17841619
function bashy_join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

