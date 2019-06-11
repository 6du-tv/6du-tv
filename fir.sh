#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname
./release.sh
fir publish build/app/outputs/apk/$version/app-$version.apk
