#!/bin/bash
set -euo pipefail
source scripts/macos-notary.sh
app_source=$1
zip=$2
dmg=$3
scratch=$(mktemp -d .build/marmot-release.XXXXXXXX)
trap 'rm -rf "$scratch"' EXIT
mkdir "$scratch/stage"
app="$scratch/stage/Marmot.app"
ditto "$app_source" "$app"
sparkle="$app/Contents/Frameworks/Sparkle.framework"
version="$sparkle/Versions/Current"
sign=(codesign --force --options runtime --timestamp --sign "$MACOS_SIGN_IDENTITY")
"${sign[@]}" "$version/XPCServices/Installer.xpc" "$version/Autoupdate" "$version/Updater.app"
"${sign[@]}" --preserve-metadata=entitlements "$version/XPCServices/Downloader.xpc"
"${sign[@]}" "$sparkle"
"${sign[@]}" --entitlements packaging/Marmot.entitlements "$app"
codesign -d --entitlements - --xml "$app" 2>/dev/null | grep -q com.apple.security.automation.apple-events \
  || { echo "Marmot.app is missing the Apple Events entitlement" >&2; exit 1; }
notarize_app "$app" "$scratch/notary.zip"

ditto -c -k --sequesterRsrc --keepParent "$app" "$scratch/$zip"
ditto -x -k "$scratch/$zip" "$scratch/unzipped"
verify_signature "$scratch/unzipped/Marmot.app"
xcrun stapler validate "$scratch/unzipped/Marmot.app"
ln -s /Applications "$scratch/stage/Applications"
hdiutil create -quiet -volname Marmot -srcfolder "$scratch/stage" -fs HFS+ -format UDZO "$scratch/$dmg"
notarize_dmg "$scratch/$dmg"
mv "$scratch/$zip" "$scratch/$dmg" .
