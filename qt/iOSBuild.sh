#!/bin/bash

# qt configuration
QT_DIR=
QT_VERSION=

# project configuration
OUT_DIR=
IN_DIR=
PRO_FILE=

# iOS build
# TODO check if it already exists
mkdir "$OUT_DIR/iOS/"
$QT_DIR/$QT_VERSION/ios/bin/qmake "$PRO_FILE" -o "$OUT_DIR/iOS/Makefile" -r -spec macx-ios-clang CONFIG+=qtquickcompiler CONFIG+=production CONFIG+=release CONFIG+=iphoneos CONFIG+=device
xcodebuild -project $OUTDIR/iOS/DateNow.xcodeproj
