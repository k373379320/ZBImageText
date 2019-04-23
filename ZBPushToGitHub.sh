#! /bin/bash

echo "pod update..."

git add .
git commit  -m "优化代码逻辑"
git tag "0.1.4"
git push origin master
git push --tags
pod spec lint --verbose ZBImageText.podspec --allow-warnings
# pod trunk push ZBImageText.podspec --allow-warnings --verbose
