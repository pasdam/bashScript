#!/bin/bash

# qt configuration
QT_DIR=
QT_VERSION=

# android configuration
ANDROID_SDK_ROOT=
ANDROID_NDK_ROOT=
# set ndk path as environment variable
export ANDROID_SDK_ROOT
export ANDROID_NDK_ROOT

# java configuration
JDK_PATH=

# project configuration
OUT_DIR=
PROJECT_DIR=
PRO_FILE=

# keystore configuration
KEYSTORE_PATH=
KEY=
CERTIFICATE_ALIAS=

# android build
$QTDIR/$QTVERSION/android_armv7/bin/qmake "$PRO_FILE" -o "$OUTDIR/android/Makefile" -r -spec android-g++ CONFIG+=qtquickcompiler CONFIG+=production
cd "$OUT_DIR/android/"
make
make install INSTALL_ROOT="$OUT_DIR/android/build"
$QT_DIR/$QT_VERSION/android_armv7/bin/androiddeployqt --input "$OUT_DIR/android/android-libDateNow.so-deployment-settings.json" --output "$OUT_DIR/android/build" --deployment bundled --jdk "$JDK_PATH" --gradle --sign "$KEYSTORE_PATH" $CERTIFICATE_ALIAS --storepass $KEY --verbose
