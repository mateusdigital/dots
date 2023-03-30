#!/usr/bin/env bash

readonly submodule_name="$1";

echo "---> Removing submodule ${submodule_name}";

git submodule deinit -f "${submodule_name}";
git rm -f "${submodule_name}"
rm -rf ".git/modules/${submodule_name}"

git commit -m "---> Deleted submodule ${submodule_name}";