#!/usr/bin/env sh

_dirname=$(cd "$(dirname "$0")"; pwd)

cd $_dirname

if [ ! -d "$_dirname/version" ]; then
git clone git@6du.bitbucket.org:6du_tv/version.git --depth=1
cat <<EOF > version/.git/config
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
    ignorecase = true
[remote "origin"]
    url = git@6du.gitee.com:www-6du-tv/6du-tv-version.git
    fetch = +refs/heads/*:refs/remotes/origin/*
    pushurl = git@6du.bitbucket.org:6du_tv/version.git
    pushurl = git@eyun.github.com:6du-tv/6du-tv-version.git
    pushurl = git@6du.gitee.com:www-6du-tv/6du-tv-version.git
EOF
fi

cd version

git add -u
git commit -m"."
git push

npm publish
