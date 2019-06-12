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

cd $DIR
mv build/app/outputs/apk/release/app-release.apk 6du.tv.apk
bash github.sh @(version)

cd $DIR
echo @(version) > npm/version/n.txt

url=`wget -qO- https://pypi.org/pypi/6du.tv/json | python3 -c "import sys, json;from distutils.version import StrictVersion;print((sorted(json.load(sys.stdin)['releases'].items(),key=lambda x:StrictVersion(x[0]),reverse=True))[0][1][0]['url'],end='')"`
echo $url

bash npm/version.sh

cd $DIR
rm 6du.tv.apk
