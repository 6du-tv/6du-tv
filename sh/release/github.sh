#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname

version=0.0.1
git add -u
git commit -m"~"
git tag v$version
git push origin v$version

# source ./release.sh
tar -czvf 6du.tv.tgz 6du.tv.apk

export GITHUB_TOKEN=`cat ~/.github/6du`
github-release upload \
  --owner 6du-tv \
  --repo 6du-tv \
  --tag "v$version" \
  --name "$version" \
  --body "" $_dirname/6du.tv.tgz

# curl https://pypi.org/pypi/6du.tv/json

# GIT=~/git/apk
# cp $APK $GIT/$version.apk
# cd $GIT
# git add $version.apk
# git commit -m"~"
# git push origin master
