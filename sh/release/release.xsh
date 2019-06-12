#!/usr/bin/env xonsh
from os.path import dirname,abspath
import os

ROOT = dirname(dirname(dirname(abspath(__file__))))
cd @(ROOT)

version = $(cat pubspec.yaml|grep "^version:").split(":").pop().strip()

version, build = version.split("+")
build = int(build)+1
version = list(map(int,version.split(".")))
version[-1]+=1
version = ".".join(list(map(str,version)))

print(f"{version}+{build}")
# echo @(version) > version.txt
