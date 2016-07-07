#!/bin/bash

# qt configuration
QT_DIR=
QT_VERSION=

# project configuration
OUT_DIR=
IN_DIR=
PRO_FILE=

# iOS build
if [ ! -d "$OUT_DIR" ]; then
	mkdir "$OUT_DIR"
fi
$QT_DIR/$QT_VERSION/ios/bin/qmake "$PRO_FILE" -o "$OUT_DIR/Makefile" -r -spec macx-ios-clang CONFIG+=qtquickcompiler CONFIG+=production CONFIG+=release CONFIG+=iphoneos CONFIG+=device
xcodebuild -project $OUTDIR/DateNow.xcodeproj
