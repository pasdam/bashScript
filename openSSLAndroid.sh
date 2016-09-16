#!/bin/bash

OPENSSL_VERSION=1.0.2h
# directory containing the openSSL archive
WORKING_DIR=
# root directory of the android NDK
NDK_ROOT=
PLATFORM_VERSION=19
TOOLCHAIN_VERSION=4.9
# It could be one of the following: arm, x86
ARCH=x86

CONFIG=
TOOLCHAIN_ARCH=
if [ "$ARCH" = "arm" ]
then
	CONFIG=armv7
	TOOLCHAIN_ARCH=arm-linux-androideabi

	export ARCH_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
	export ARCH_LINK="-march=armv7-a -Wl,--fix-cortex-a8"
	export TOOL=arm-linux-androideabi

elif [ "$ARCH" = "x86" ]
then
	CONFIG=x86
	TOOLCHAIN_ARCH=x86

	export ARCH_FLAGS="-march=i686 -msse3 -mstackrealign -mfpmath=sse"
	export ARCH_LINK=
	export TOOL=i686-linux-android

else
	# invalid input
	>&2 echo "Invalid architecture: "$ARCH
	exit -1
fi

tar xzf $WORKING_DIR/openssl-$OPENSSL_VERSION.tar.gz
cd openssl-$OPENSSL_VERSION

export NDK=$NDK_ROOT
export TOOLCHAIN_PATH=`pwd`/android-toolchain-$ARCH/bin
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=$NDK_TOOLCHAIN_BASENAME-gcc
export CXX=$NDK_TOOLCHAIN_BASENAME-g++
export LINK=${CXX}
export LD=$NDK_TOOLCHAIN_BASENAME-ld
export AR=$NDK_TOOLCHAIN_BASENAME-ar
export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} "

$NDK/build/tools/make-standalone-toolchain.sh --platform=android-$PLATFORM_VERSION --toolchain=$TOOLCHAIN_ARCH-$TOOLCHAIN_VERSION --install-dir=`pwd`/android-toolchain-$ARCH

./Configure shared android-$CONFIG

# fix makefile
perl -p -i.bkp -e 's#LIBNAME=\$\$i LIBVERSION=\$\(SHLIB_MAJOR\).\$\(SHLIB_MINOR\)#LIBNAME=\$\$i#' Makefile
#perl -p -e 's#LIBCOMPATVERSIONS=";\$\(SHLIB_VERSION_HISTORY\)\" \\##' Makefile

PATH=$TOOLCHAIN_PATH:$PATH make build_libs
