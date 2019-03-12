#! /bin/bash

echo "pod update..."

git add .
git commit  -m "feature:增加一些钩子,方便自定义扩展"
git tag "0.0.7"
git push origin master
git push --tags
pod trunk push ZBImageText.podspec --allow-warnings
