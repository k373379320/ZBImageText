#! /bin/bash

echo "pod update..."

git add .
git commit  -m "feature:优化代码"
git tag "0.0.9"
git push origin master
git push --tags
pod trunk push ZBImageText.podspec --allow-warnings
