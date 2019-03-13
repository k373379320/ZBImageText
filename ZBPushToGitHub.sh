#! /bin/bash

echo "pod update..."

git add .
git commit  -m "feature:增加image/text 的tap事件回调;增加text删除线功能"
git tag "0.0.8"
git push origin master
git push --tags
pod trunk push ZBImageText.podspec --allow-warnings
