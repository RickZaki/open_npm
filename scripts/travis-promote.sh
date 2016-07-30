#!/bin/bash -e

BRANCH_TO_MERGE_FROM="develop"
BRANCH_TO_MERGE_INTO="master"
GITHUB_REPO="RickZaki/open_npm.git"
git config --global user.email "travis@RickZaki.com"
git config --global user.name "Travis CI"
push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$GITHUB_REPO"


if [ "$TRAVIS_BRANCH" != "$BRANCH_TO_MERGE_FROM" ]; then
    printf 'bailing early since not %s\n' "$BRANCH_TO_MERGE_FROM" >&2
    exit 0;
fi


# Since Travis does a partial checkout, we need to get the whole thing
repo_temp=$(mktemp -d)
git clone "https://github.com/$GITHUB_REPO" "$repo_temp"

# shellcheck disable=SC2164
cd "$repo_temp"

printf 'Checking out %s\n' "$BRANCH_TO_MERGE_INTO" >&2
git checkout "$BRANCH_TO_MERGE_INTO"

printf 'Merging %s\n' "$BRANCH_TO_MERGE_FROM" >&2
git merge "$BRANCH_TO_MERGE_FROM"

printf 'Bumping package version\n' >&2
npm version patch

printf 'Pushing to %s\n' "$BRANCH_TO_MERGE_INTO" >&2
git push --tags "$push_uri" "$BRANCH_TO_MERGE_INTO" >/dev/null 2>&1

printf 'Checking out %s\n' "$BRANCH_TO_MERGE_FROM" >&2
git checkout "$BRANCH_TO_MERGE_FROM"

printf 'Merging %s\n' "$BRANCH_TO_MERGE_INTO" >&2
git merge --no-commit "$BRANCH_TO_MERGE_INTO"
git commit -m 'Keeping branches in sync [ci skip]'
git push "$push_uri" "$BRANCH_TO_MERGE_FROM" >/dev/null 2>&1