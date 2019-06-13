#!/usr/bin/env xonsh
$RAISE_SUBPROC_ERROR = True
import json
from os.path import dirname,abspath
import os

$DIR = dirname(abspath(__file__))
$ROOT = dirname(dirname($DIR))
cd $ROOT

version = $(cat pubspec.yaml|grep "^version:").split(":").pop().strip()
version, build = version.split("+")
build = int(build)+1
version = list(map(int,version.split(".")))
version[-1]+=1


version = ".".join(list(map(str,version)))
print(version)

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

url_li = [
    f"github.com/6du-tv/6du-tv/releases/download/v{version}/6du.tv.tgz",
]

$pypi_url=f"https://pypi.org/pypi/6du.tv/{version}/json"
echo $pypi_url
url = json.loads($(wget -qO- $pypi_url))['urls'][0]['url'][8:]
url_li.append(url)
url = url.split("/",1)

for host in "pypi.doubanio.com pypi.tuna.tsinghua.edu.cn mirrors.aliyun.com/pypi".split(' '):
    url[0] = host
    url_li.append("/".join(url))

npm_url = f"/6du-tv-apk/-/6du-tv-apk-{version}.tgz"

for host in "registry.npmjs.org registry.npm.taobao.org r.cnpmjs.org".split(' '):
    url_li.append(host+npm_url)

with open("npm/version/n.txt","w") as f:
    f.write("\n".join(url_li))

sed -i '/\"version\"/c$json_version' npm/version/package.json
./npm/version.sh

cd $DIR
rm 6du.tv.apk
