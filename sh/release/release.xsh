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

cp $DIR/6du.tv.apk $DIR/pypi
bash $DIR/pypi/dist.sh

cd $DIR
cp 6du.tv.apk npm/apk
$json_version = rf"\ \ \ \ \"version\":\"{version}\","
sed -i '/\"version\"/c$json_version' npm/apk/package.json
cd $DIR/npm/apk
npm publish

mv build/app/outputs/apk/release/app-release.apk $DIR/6du.tv.apk
bash $DIR/github.sh @(version)

cd $DIR
echo @(version) > npm/version/n.txt
bash npm/version.sh
