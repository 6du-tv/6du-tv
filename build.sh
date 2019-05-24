#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname

version=debug
flutter build apk --$version
#flutter build apk --release
fir publish build/app/outputs/apk/$version/app-$version.apk
