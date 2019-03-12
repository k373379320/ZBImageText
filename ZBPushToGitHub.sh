#! /bin/bash

echo "pod update..."

git add .
git commit  -m "feature:增加直接生成attributedString的api,以及性能测试界面"
git tag "0.0.6"
git push origin master
git push --tags
pod trunk push ZBImageText.podspec --allow-warnings
