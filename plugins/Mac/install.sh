#!/bin/sh
DSTDIR="../../build/Packager/Assets/Plugins"
rm -rf DerivedData
xcodebuild -scheme SystemFontRenderer -configuration Release build
mkdir -p $DSTDIR
cp -r DerivedData/SystemFontRenderer/Build/Products/Release/SystemFontRenderer.bundle $DSTDIR
rm -rf DerivedData
