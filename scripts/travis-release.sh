#!/bin/bash -e

if [ "$TRAVIS_BRANCH" != "master" ]; then
    printf 'bailing early since not master\n'
    exit 0
fi


GITHUB_REPO="RickZaki/open_npm.git"
export GIT_COMMITTER_EMAIL='travis@RickZaki.com'
export GIT_COMMITTER_NAME='Travis CI'
push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$GITHUB_REPO"



# Since Travis does a partial checkout, we need to get the whole thing
repo_temp=$(mktemp -d)
git clone "https://github.com/$GITHUB_REPO" "$repo_temp"

# shellcheck disable=SC2164
cd "$repo_temp"

VERSION=`node -e "console.log('v' + require('./package.json').version);"`
printf 'Tagging %s\n' "$VERSION" >&2
git tag -a $VERSION -m "tagging for release $VERSION"

printf 'Pushing to %s\n' "$GITHUB_REPO" >&2
git push --tags "$push_uri" >/dev/null 2>&1