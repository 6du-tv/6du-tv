#!/usr/bin/env bash

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname
python setup.py sdist upload -r pypi
rm -rf dist
