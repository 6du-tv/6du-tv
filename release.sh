#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname

#out=debug
out=release

flutter build apk --$out
APK=build/app/outputs/apk/$out/app-$out.apk
