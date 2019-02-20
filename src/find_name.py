#!/usr/bin/env python

import sys;
import getopt;
import os;

def fatal(msg):
    print msg;
    sys.exit(1);

def main():
    try:
        opts, args = getopt.gnu_getopt(
            sys.argv[1:],
            "",
            ["path=", "ignore="]
        );

    except Exception as e:
        fatal(str(e));

    ##
    ## Parse the command line arguments.
    if(len(args) == 0):
        fatal("Missing name to find - Aborting");

    name_to_find = args[0];
    start_path   = ".";
    ignore_paths = [];

    for o, a in opts:
        if(o in ("-i", "--ignore")): ignore_paths.append(a);
        if(a in ("-p", "--path"  )): start_path = a;

    ## Build the find(1) command
    cmd_find = "find {start_path} -iname \"{name_to_find}\" ".format(
        start_path   = start_path,
        name_to_find = name_to_find
    );
    for ignore_path in ignore_paths:
        cmd_find += "! -path \"{ignore_path}\" ".format(
            ignore_path = ignore_path
        );

    os.system(cmd_find);

if __name__ == "__main__":
    main();
