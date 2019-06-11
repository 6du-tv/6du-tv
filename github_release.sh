#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname

version=0.0.1
git add -u
git commit -m"."

git tag v$version
source ./release.sh

github-release upload \
  --owner 6du-tv \
  --repo 6du-tv \
  --tag "v$version" \
  --name "$version" \
  --body "" $APK
