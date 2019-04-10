#! /bin/bash

echo "pod update..."

git add .
git commit  -m "feature:新增font,color容错,优化Color Blended Layers"
git tag "0.1.3"
git push origin master
git push --tags
#pod spec lint --verbose ZBImageText.podspec --allow-warnings
pod trunk push ZBImageText.podspec --allow-warnings --verbose
