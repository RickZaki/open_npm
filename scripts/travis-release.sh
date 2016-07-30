#!/bin/bash -e

if [ "$TRAVIS_BRANCH" != "master" ]; then
    printf 'bailing early since not %s\n' "$TRAVIS_BRANCH";
    exit 0;
fi

npm version patch -m "tagging release version [ci skip]";
