#!/bin/bash

set -ex

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GIT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$GIT_ROOT" || exit

rm -rf build Payload dauphin.ipa

 xcodebuild -project "$GIT_ROOT/app/dauphin.xcodeproj" \
 -scheme dauphin -configuration Release \
 -derivedDataPath "$GIT_ROOT/build" \
 -destination 'generic/platform=iOS' \
 -sdk iphoneos \
 clean build \
 CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO

find build/Build/Products/Release-iphoneos/dauphin.app \
  -type f \( -name "*.appex" -o -name "dauphin" \) \
  -print0 | xargs -0 -I{} ldid -S -M {}
ln -sf build/Build/Products/Release-iphoneos Payload
zip -r9 dauphin.ipa Payload/dauphin.app
