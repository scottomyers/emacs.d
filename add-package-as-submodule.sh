#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: $0 package-name url git-branch"
    exit 1
fi

git subtree add --prefix="site-lisp/${1}" "${2}" "${3}" --squash
