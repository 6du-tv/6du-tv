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


./build.sh

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

url=`wget -qO- https://pypi.org/pypi/6du.tv/json | python3 -c "import sys,json;print(json.load(sys.stdin)['urls'][0]['url'][8:],end='')"`

url_li = [url]
url = url.split("/",1)

for host in "pypi.doubanio.com pypi.tuna.tsinghua.edu.cn mirrors.aliyun.com/pypi".split(' ')
    url[0] = host
    url_li.append("/".join(url))


bash npm/version.sh

cd $DIR
rm 6du.tv.apk
