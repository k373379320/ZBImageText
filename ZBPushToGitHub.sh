#! /bin/bash

echo "pod update..."

git add .
git commit  -m "0.0.2"
git tag "0.0.2"
git push origin master
git push --tags
pod trunk push ZBImageText.podspec --allow-warnings