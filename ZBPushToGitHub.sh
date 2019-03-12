#! /bin/bash

echo "pod update..."

git add .
git commit  -m "fix:增加safe,对dict取值容错"
git tag "0.0.5"
git push origin master
git push --tags
pod trunk push ZBImageText.podspec --allow-warnings
