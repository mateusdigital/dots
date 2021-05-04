
##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : datetime.sh                                                   ##
##  Project   : dots                                                          ##
##  Date      : Feb 06, 2020                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2020                                                  ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

## @notice: Since we need to be in GNU/Linux to build for DOS we need a
## way to specify to cmake that we are interested on build for it, not for
## gnu itself.
## This var will control how the other cmake-xyz function prepare the
## directories and the building. - stdmatt, 5/4/2021, 1:03:40 PM
##------------------------------------------------------------------------
cmake-set-for()
{
    if [ "$1" == "DOS" ]; then
        export _STDMATT_CMAKE_BUILD_FOR_DOS=1;
        echo "[cmake-set-for] Building for DOS.";
    else
        export _STDMATT_CMAKE_BUILD_FOR_DOS=0;
        echo "[cmake-set-for] Building for GNU/Linux.";
    fi;
}

##------------------------------------------------------------------------
_cmake_get_build_dir_name()
{
    BUILD_DIR="build.gnu_linux";
    if [ $_STDMATT_CMAKE_BUILD_FOR_DOS ]; then
        BUILD_DIR="build.dos"
    fi;
    echo $BUILD_DIR;
}

##------------------------------------------------------------------------
_cmake_get_default_build_args()
{
    BUILD_ARGS="";
    if [ $_STDMATT_CMAKE_BUILD_FOR_DOS ]; then
        BUILD_ARGS="-DBUILD_FOR_DOS=ON"
    fi;
    echo "$BUILD_ARGS";
}

##------------------------------------------------------------------------
_cmake_ensure_dir()
{
    if [ ! -d $BUILD_DIR ]; then
        mkdir -p $BUILD_DIR;
    fi;
}

## @notice(stdmatt): Backported from powershell version...
##------------------------------------------------------------------------
function cmake-gen()
{
    CMAKE_SCRIPT_FILENAME="CMakeLists.txt";
    if [ ! -f $CMAKE_SCRIPT_FILENAME ]; then
        echo "Current directory doesn't have a ($CMAKE_SCRIPT_FILENAME)";
        return;
    fi;

    BUILD_DIR=$(_cmake_get_build_dir_name);
    BUILD_ARGS=$(_cmake_get_default_build_args);

    _cmake_ensure_dir $BUILD_DIR;
    cd $BUILD_DIR;
        cmake $BUILD_ARGS $@ ..
    cd -;
}

##------------------------------------------------------------------------------
function cmake-build()
{
    cmake-gen;

    BUILD_DIR=$(_cmake_get_build_dir_name);
    BUILD_ARGS=$(_cmake_get_default_build_args);

    _cmake_ensure_dir $BUILD_DIR;
    cd $BUILD_DIR;
        cmake $BUILD_ARGS $@ --build .
    cd -;
}
