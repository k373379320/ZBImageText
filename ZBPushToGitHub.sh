#! /bin/bash

echo "pod update..."

git add .
git commit  -m "增加一些api,测试样式,优化代码"
git tag "0.1.8"
git push origin master
git push --tags
# pod spec lint --verbose ZBImageText.podspec --allow-warnings
pod trunk push ZBImageText.podspec --allow-warnings --verbose
