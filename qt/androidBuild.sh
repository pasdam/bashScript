#!/bin/bash

# qt configuration
QTDIR=
QTVERSION=

# android configuration
ANDROID_SDK_ROOT=
ANDROID_NDK_ROOT=
# set ndk path as environment variable
export ANDROID_SDK_ROOT
export ANDROID_NDK_ROOT

# java configuration
JDK_PATH=

# project configuration
OUTDIR=
PROJECT_DIR=
PRO_FILE=

# keystore configuration
KEYSTORE_PATH=
KEY=
CERTIFICATE_ALIAS=

# android build
$QTDIR/$QTVERSION/android_armv7/bin/qmake $PRO_FILE -o $OUTDIR/android/Makefile -r -spec android-g++ CONFIG+=qtquickcompiler CONFIG+=production
cd $OUTDIR/android/
make -j6
make install INSTALL_ROOT=$OUTDIR/android/build
$QTDIR/$QTVERSION/android_armv7/bin/androiddeployqt --input $OUTDIR/android/android-libDateNow.so-deployment-settings.json --output $OUTDIR/android/build --deployment bundled --jdk $JDK_PATH --gradle --sign $KEYSTORE_PATH $CERTIFICATE_ALIAS --storepass $KEY --verbose
