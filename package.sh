#!/bin/bash

zip -x "*.zip" -x "dist/" -x "dist/**" -x ".git/" -x "/.git/**" -x "package.sh" -x "README.md" -9 -r dist/sunrunner.love .
cat dist/love.exe dist/sunrunner.love > dist/sunrunner.exe
rm dist/sunrunner.love
cd dist
zip -x "love.exe" -9 -r ../sunrunner-$(date +%Y%m%d-%H%M%S).zip .
cd ..
