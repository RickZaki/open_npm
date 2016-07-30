#!/bin/bash -e

if [ "$TRAVIS_BRANCH" != "develop" ]; then
    printf 'bailing early since not develop\n'
    exit 0;
fi


BRANCH_TO_MERGE_INTO="master"
GITHUB_REPO="RickZaki/open_npm.git"
export GIT_COMMITTER_EMAIL='travis@RickZaki.com'
export GIT_COMMITTER_NAME='Travis CI'
push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$GITHUB_REPO"


# Since Travis does a partial checkout, we need to get the whole thing
repo_temp=$(mktemp -d)
git clone "https://github.com/$GITHUB_REPO" "$repo_temp"

# shellcheck disable=SC2164
cd "$repo_temp"

printf 'Bumping package version\n' >&2
npm --no-git-tag-version version patch
git add package.json
git commit -m "bumping version for release [ci skip]"

printf 'Pushing to %s\n' "$TRAVIS_BRANCH" >&2
git push "$push_uri" "$TRAVIS_BRANCH" >/dev/null 2>&1

printf 'Checking out %s\n' "$BRANCH_TO_MERGE_INTO" >&2
git checkout "$BRANCH_TO_MERGE_INTO"

printf 'Merging %s\n' "$TRAVIS_COMMIT" >&2
git merge --ff-only "$TRAVIS_COMMIT"

printf 'Pushing to %s\n' "$GITHUB_REPO" >&2
git push "$push_uri" "$BRANCH_TO_MERGE_INTO" >/dev/null 2>&1
