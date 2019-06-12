#!/usr/bin/env xonsh
from os.path import dirname,abspath
import os

$DIR = dirname(abspath(__file__))
$ROOT = dirname(dirname($DIR))
cd $ROOT

version = $(cat pubspec.yaml|grep "^version:").split(":").pop().strip()
print(version)
version, build = version.split("+")
build = int(build)+1
version = list(map(int,version.split(".")))
version[-1]+=1


version = ".".join(list(map(str,version)))

$pubspec_version = f"version: {version}+{build}"

sed -i '/^version:/c $pubspec_version' pubspec.yaml


./release.sh


$python_version = rf"\ \ \ \ version='{version}',"
sed -i '/version=/c$python_version' $DIR/pypi/setup.py 

echo @(version) > $DIR/npm/version/n.txt

# echo @(version) > version.txt
