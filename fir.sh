#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname
source ./release.sh
fir publish $APK
