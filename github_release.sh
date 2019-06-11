#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname
source ./release.sh

github-release upload \
  --owner 6du-tv \
  --repo 6du-tv \
  --tag "v0.0.1" \
  --name "v0.0.1" \
  --body "" $APK
