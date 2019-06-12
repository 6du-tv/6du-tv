#!/usr/bin/env xonsh
from os.path import dirname,abspath

ROOT = abspath(dirname(__file__))

cd @(ROOT)

version = list(map(int,$(cat version.txt).split(".")))

version[-1]+=1

version = ".".join(list(map(str,version)))

echo @(version) > version.txt
