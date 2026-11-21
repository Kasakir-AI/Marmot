#!/bin/sh
# Regenerates packaging/homebrew/marmot.rb for the current release disk image.
# Run after `make release`, then copy the file into the tap repo:
#   github.com/Kasakir-AI/homebrew-tap → Casks/marmot.rb
set -e
cd "$(dirname "$0")/.."

VERSION=$(grep '^VERSION' Makefile | head -1 | sed 's/.*= *//')
DMG="Marmot-$VERSION.dmg"
[ -f "$DMG" ] || { echo "Missing $DMG — run 'make release' first."; exit 1; }
SHA=$(shasum -a 256 "$DMG" | awk '{print $1}')

cat > packaging/homebrew/marmot.rb << EOF
# frozen_string_literal: true

# Homebrew cask for Marmot.
# Lives in the tap repo: github.com/Kasakir-AI/homebrew-tap (Casks/marmot.rb)
# Regenerate for each release with: sh scripts/make-cask.sh
cask "marmot" do
  version "$VERSION"
  sha256 "$SHA"

  url "https://github.com/Kasakir-AI/Marmot/releases/download/v#{version}/Marmot-#{version}.dmg"
  name "Marmot"
  desc "Free, open-source disk cleaner that shows everything before it touches anything"
  homepage "https://github.com/Kasakir-AI/Marmot"

  # Marmot updates itself via Sparkle after install.
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Marmot.app"

  # Quit Marmot first so upgrades and uninstalls replace or remove it cleanly.
  uninstall quit: "dev.marmot.app"

  zap trash: [
    "~/Library/Application Support/Marmot",
    "~/Library/Caches/dev.marmot.app",
    "~/Library/HTTPStorages/dev.marmot.app",
    "~/Library/Preferences/dev.marmot.app.plist",
    "~/Library/Saved Application State/dev.marmot.app.savedState",
  ]
end
EOF

echo "packaging/homebrew/marmot.rb updated for $VERSION ($SHA)"
echo "Copy it to the homebrew-tap repo as Casks/marmot.rb and push."
