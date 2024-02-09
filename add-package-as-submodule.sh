#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 package-name url"
    exit 1
fi

git submodule add "${2}" "./site-lisp/${1}"
