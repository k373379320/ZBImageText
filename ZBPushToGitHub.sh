#! /bin/bash

echo "pod update..."

git add .
git commit  -m "fix:解决圆角问题"
git tag "0.1.7"
git push origin master
git push --tags
# pod spec lint --verbose ZBImageText.podspec --allow-warnings
pod trunk push ZBImageText.podspec --allow-warnings --verbose
