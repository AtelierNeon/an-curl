#!/usr/bin/env bash

##
## Global config
##
CMAKE_CLI=cmake
DIRNAME_CLI=/usr/bin/dirname
PWD_CLI=/bin/pwd
UNAME_CLI=/usr/bin/uname
SCRIPT_DIR=$(cd -- "$(${DIRNAME_CLI} "${BASH_SOURCE[0]:-${(%):-%x}}")" &> /dev/null && ${PWD_CLI})
SYSTEM_PLATFORM=$($UNAME_CLI)
PROJECT_DIR=$SCRIPT_DIR/..
SOURCE_DIR=$PROJECT_DIR
TEMP_ROOT_DIR=$PROJECT_DIR/build
TEMP_BUILD_DIR=$TEMP_ROOT_DIR/t
TEMP_INSTALL_DIR=$TEMP_ROOT_DIR/i

##
## Project config
##
####
#### Project level config
####
PROJECT_GCC_AR_NAME="${MY_PROJECT_GCC_AR_NAME:=ar}"
PROJECT_GCC_C_COMPILER_NAME="${MY_PROJECT_GCC_C_COMPILER_NAME:=gcc-11}"
PROJECT_GCC_CXX_COMPILER_NAME="${MY_PROJECT_GCC_CXX_COMPILER_NAME:=g++-11}"
PROJECT_GCC_LD_NAME="${MY_PROJECT_GCC_LD_NAME:=ld}"
PROJECT_GCC_OS_NAME="${MY_PROJECT_GCC_OS_NAME:=linux}"
PROJECT_REVISION="${BUILD_NUMBER:=9999}"
PROJECT_RELEASE_TYPE="${MY_PROJECT_RELEASE_TYPE:=Debug}"
PROJECT_WITH_OPENSSL_1_1_1_PREFERRED="${MY_PROJECT_WITH_OPENSSL_1_1_1_PREFERRED:=OFF}"
PROJECT_WITH_OPENSSL_3_0_PREFERRED="${MY_PROJECT_WITH_OPENSSL_3_0_PREFERRED:=OFF}"
PROJECT_SHOULD_DISABLE_CLEAN_BUILD="${MY_PROJECT_SHOULD_DISABLE_CLEAN_BUILD:=OFF}"
PROJECT_SHOULD_DISABLE_32BIT_BUILD="${MY_PROJECT_SHOULD_DISABLE_32BIT_BUILD:=OFF}"
PROJECT_SHOULD_DISABLE_64BIT_BUILD="${MY_PROJECT_SHOULD_DISABLE_64BIT_BUILD:=OFF}"
PROJECT_SHOULD_DISABLE_ARM_BUILD="${MY_PROJECT_SHOULD_DISABLE_ARM_BUILD:=OFF}"
PROJECT_SHOULD_DISABLE_X86_BUILD="${MY_PROJECT_SHOULD_DISABLE_X86_BUILD:=OFF}"
####
#### Project component level config
####
PROJECT_CARES_WITHOUT_APPS="${MY_PROJECT_CARES_WITHOUT_APPS:=OFF}"
PROJECT_CARES_WITHOUT_TEST_APPS="${MY_PROJECT_CARES_WITHOUT_TEST_APPS:=OFF}"
PROJECT_CURL_WITH_LIBSSH2="${MY_PROJECT_CURL_WITH_LIBSSH2:=OFF}"
PROJECT_CURL_WITH_NGHTTP2="${MY_PROJECT_CURL_WITH_NGHTTP2:=OFF}"
PROJECT_CURL_WITH_OPENSSL="${MY_PROJECT_CURL_WITH_OPENSSL:=OFF}"
PROJECT_CURL_WITH_SHARED_LIBRARIES="${MY_PROJECT_CURL_WITH_SHARED_LIBRARIES:=OFF}"
PROJECT_CURL_WITH_SHARED_LIBSSH2="${MY_PROJECT_CURL_WITH_SHARED_LIBSSH2:=OFF}"
PROJECT_CURL_WITH_SHARED_NGHTTP2="${MY_PROJECT_CURL_WITH_SHARED_NGHTTP2:=OFF}"
PROJECT_CURL_WITH_SHARED_ZLIB="${MY_PROJECT_CURL_WITH_SHARED_ZLIB:=OFF}"
PROJECT_CURL_WITH_ZLIB="${MY_PROJECT_CURL_WITH_ZLIB:=OFF}"
PROJECT_CURL_WITHOUT_APPS="${MY_PROJECT_CURL_WITHOUT_APPS:=OFF}"
PROJECT_LIBSSH2_WITH_SHARED_LIBRARIES="${MY_PROJECT_LIBSSH2_WITH_SHARED_LIBRARIES:=OFF}"
PROJECT_LIBSSH2_WITH_SHARED_ZLIB="${MY_PROJECT_LIBSSH2_WITH_SHARED_ZLIB:=OFF}"
PROJECT_LIBSSH2_WITH_ZLIB="${MY_PROJECT_LIBSSH2_WITH_ZLIB:=OFF}"
PROJECT_LIBSSH2_WITHOUT_TEST_APPS="${MY_PROJECT_LIBSSH2_WITHOUT_TEST_APPS:=OFF}"
PROJECT_NGHTTP2_WITHOUT_TEST_APPS="${MY_PROJECT_NGHTTP2_WITHOUT_TEST_APPS:=OFF}"
PROJECT_OPENSSL_WITH_DEPRECATED_CIPHERS="${MY_PROJECT_OPENSSL_WITH_DEPRECATED_CIPHERS:=OFF}"
PROJECT_OPENSSL_WITH_SHARED_LIBRARIES="${MY_PROJECT_OPENSSL_WITH_SHARED_LIBRARIES:=OFF}"
PROJECT_OPENSSL_WITH_SHARED_ZLIB="${MY_PROJECT_OPENSSL_WITH_SHARED_ZLIB:=OFF}"
PROJECT_OPENSSL_WITH_ZLIB="${MY_PROJECT_OPENSSL_WITH_ZLIB:=OFF}"
PROJECT_OPENSSL_WITHOUT_APPS="${MY_PROJECT_OPENSSL_WITHOUT_APPS:=OFF}"
PROJECT_ZLIB_WITHOUT_TEST_APPS="${MY_PROJECT_ZLIB_WITHOUT_TEST_APPS:=OFF}"

##
## My variables
##
MY_CMAKE_COMMON_ARGUMENT_LIST=(
        "-S $SOURCE_DIR"
        "-DMY_REVISION=$PROJECT_REVISION"
        "-DCMAKE_SYSTEM_NAME=$SYSTEM_PLATFORM"
        "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
        "-DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF"
)
if [ "ON" = "$PROJECT_CARES_WITHOUT_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCARES_WITHOUT_APPS=$PROJECT_CARES_WITHOUT_APPS")
fi
if [ "ON" = "$PROJECT_CARES_WITHOUT_TEST_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCARES_WITHOUT_TEST_APPS=$PROJECT_CARES_WITHOUT_TEST_APPS")
fi
if [ "ON" = "$PROJECT_CURL_WITH_LIBSSH2" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_LIBSSH2=$PROJECT_CURL_WITH_LIBSSH2")
fi
if [ "ON" = "$PROJECT_CURL_WITH_NGHTTP2" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_NGHTTP2=$PROJECT_CURL_WITH_NGHTTP2")
fi
if [ "ON" = "$PROJECT_CURL_WITH_OPENSSL" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_OPENSSL=$PROJECT_CURL_WITH_OPENSSL")
fi
if [ "ON" = "$PROJECT_CURL_WITH_SHARED_LIBRARIES" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_SHARED_LIBRARIES=$PROJECT_CURL_WITH_SHARED_LIBRARIES")
fi
if [ "ON" = "$PROJECT_CURL_WITH_SHARED_LIBSSH2" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_SHARED_LIBSSH2=$PROJECT_CURL_WITH_SHARED_LIBSSH2")
fi
if [ "ON" = "$PROJECT_CURL_WITH_SHARED_NGHTTP2" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_SHARED_NGHTTP2=$PROJECT_CURL_WITH_SHARED_NGHTTP2")
fi
if [ "ON" = "$PROJECT_CURL_WITH_SHARED_ZLIB" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_SHARED_ZLIB=$PROJECT_CURL_WITH_SHARED_ZLIB")
fi
if [ "ON" = "$PROJECT_CURL_WITH_ZLIB" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITH_ZLIB=$PROJECT_CURL_WITH_ZLIB")
fi
if [ "ON" = "$PROJECT_CURL_WITHOUT_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DCURL_WITHOUT_APPS=$PROJECT_CURL_WITHOUT_APPS")
fi
if [ "ON" = "$PROJECT_LIBSSH2_WITH_SHARED_LIBRARIES" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DLIBSSH2_WITH_SHARED_LIBRARIES=$PROJECT_LIBSSH2_WITH_SHARED_LIBRARIES")
fi
if [ "ON" = "$PROJECT_LIBSSH2_WITH_SHARED_ZLIB" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DLIBSSH2_WITH_SHARED_ZLIB=$PROJECT_LIBSSH2_WITH_SHARED_ZLIB")
fi
if [ "ON" = "$PROJECT_LIBSSH2_WITH_ZLIB" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DLIBSSH2_WITH_ZLIB=$PROJECT_LIBSSH2_WITH_ZLIB")
fi
if [ "ON" = "$PROJECT_LIBSSH2_WITHOUT_TEST_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DLIBSSH2_WITHOUT_TEST_APPS=$PROJECT_LIBSSH2_WITHOUT_TEST_APPS")
fi
if [ "ON" = "$PROJECT_NGHTTP2_WITHOUT_TEST_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DNGHTTP2_WITHOUT_TEST_APPS=$PROJECT_NGHTTP2_WITHOUT_TEST_APPS")
fi
if [ "ON" = "$PROJECT_OPENSSL_WITH_DEPRECATED_CIPHERS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DOPENSSL_WITH_DEPRECATED_CIPHERS=$PROJECT_OPENSSL_WITH_DEPRECATED_CIPHERS")
fi
if [ "ON" = "$PROJECT_OPENSSL_WITH_SHARED_LIBRARIES" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DOPENSSL_WITH_SHARED_LIBRARIES=$PROJECT_OPENSSL_WITH_SHARED_LIBRARIES")
fi
if [ "ON" = "$PROJECT_OPENSSL_WITH_SHARED_ZLIB" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DOPENSSL_WITH_SHARED_ZLIB=$PROJECT_OPENSSL_WITH_SHARED_ZLIB")
fi
if [ "ON" = "$PROJECT_OPENSSL_WITH_ZLIB" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DOPENSSL_WITH_ZLIB=$PROJECT_OPENSSL_WITH_ZLIB")
fi
if [ "ON" = "$PROJECT_OPENSSL_WITHOUT_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DOPENSSL_WITHOUT_APPS=$PROJECT_OPENSSL_WITHOUT_APPS")
fi
if [ "ON" = "$PROJECT_ZLIB_WITHOUT_TEST_APPS" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DZLIB_WITHOUT_TEST_APPS=$PROJECT_ZLIB_WITHOUT_TEST_APPS")
fi
if [ "ON" = "$PROJECT_WITH_OPENSSL_1_1_1_PREFERRED" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DBUILD_WITH_OPENSSL_1_1_1_PREFERRED=$PROJECT_WITH_OPENSSL_1_1_1_PREFERRED")
fi
if [ "ON" = "$PROJECT_WITH_OPENSSL_3_0_PREFERRED" ]; then
    MY_CMAKE_COMMON_ARGUMENT_LIST+=("-DBUILD_WITH_OPENSSL_3_0_PREFERRED=$PROJECT_WITH_OPENSSL_3_0_PREFERRED")
fi
declare -A MY_GCC_ARCH_BUILD_TOGGLE_MAP=(
        ["aarch64"]="ON"
        ["arm"]="ON"
        ["x86_64"]="ON"
)
if [ "ON" = "$PROJECT_SHOULD_DISABLE_32BIT_BUILD" ]; then
    MY_GCC_ARCH_BUILD_TOGGLE_MAP["arm"]="OFF"
fi
if [ "ON" = "$PROJECT_SHOULD_DISABLE_64BIT_BUILD" ]; then
    MY_GCC_ARCH_BUILD_TOGGLE_MAP["aarch64"]="OFF"
    MY_GCC_ARCH_BUILD_TOGGLE_MAP["x86_64"]="OFF"
fi
if [ "ON" = "$PROJECT_SHOULD_DISABLE_ARM_BUILD" ]; then
    MY_GCC_ARCH_BUILD_TOGGLE_MAP["aarch64"]="OFF"
    MY_GCC_ARCH_BUILD_TOGGLE_MAP["arm"]="OFF"
fi
if [ "ON" = "$PROJECT_SHOULD_DISABLE_X86_BUILD" ]; then
    MY_GCC_ARCH_BUILD_TOGGLE_MAP["x86_64"]="OFF"
fi



## Print build information
echo "[$SYSTEM_PLATFORM] Project information: revision: $PROJECT_REVISION"
echo "[$SYSTEM_PLATFORM] Project information: release type: $PROJECT_RELEASE_TYPE"
echo "[$SYSTEM_PLATFORM] Project information: Disable clean build: $PROJECT_SHOULD_DISABLE_CLEAN_BUILD"
echo "[$SYSTEM_PLATFORM] Project information: Preferred to use OpenSSL 1.1.1: $PROJECT_WITH_OPENSSL_1_1_1_PREFERRED"
echo "[$SYSTEM_PLATFORM] Project information: Preferred to use OpenSSL 3.0: $PROJECT_WITH_OPENSSL_3_0_PREFERRED"
echo "[$SYSTEM_PLATFORM] Component information: c-ares without apps: $PROJECT_CARES_WITHOUT_APPS"
echo "[$SYSTEM_PLATFORM] Component information: c-ares without test apps: $PROJECT_CARES_WITHOUT_TEST_APPS"
echo "[$SYSTEM_PLATFORM] Component information: CURL with libssh2: $PROJECT_CURL_WITH_LIBSSH2"
echo "[$SYSTEM_PLATFORM] Component information: CURL with nghttp2: $PROJECT_CURL_WITH_NGHTTP2"
echo "[$SYSTEM_PLATFORM] Component information: CURL with OpenSSL: $PROJECT_CURL_WITH_OPENSSL"
echo "[$SYSTEM_PLATFORM] Component information: CURL with shared libraries: $PROJECT_CURL_WITH_SHARED_LIBRARIES"
echo "[$SYSTEM_PLATFORM] Component information: CURL with shared libssh2: $PROJECT_CURL_WITH_SHARED_LIBSSH2"
echo "[$SYSTEM_PLATFORM] Component information: CURL with shared nghttp2: $PROJECT_CURL_WITH_SHARED_NGHTTP2"
echo "[$SYSTEM_PLATFORM] Component information: CURL with shared Zlib: $PROJECT_CURL_WITH_SHARED_ZLIB"
echo "[$SYSTEM_PLATFORM] Component information: CURL with Zlib: $PROJECT_CURL_WITH_ZLIB"
echo "[$SYSTEM_PLATFORM] Component information: CURL without apps: $PROJECT_CURL_WITHOUT_APPS"
echo "[$SYSTEM_PLATFORM] Component information: libssh2 with shared libraries: $PROJECT_LIBSSH2_WITH_SHARED_LIBRARIES"
echo "[$SYSTEM_PLATFORM] Component information: libssh2 with shared Zlib: $PROJECT_LIBSSH2_WITH_SHARED_ZLIB"
echo "[$SYSTEM_PLATFORM] Component information: libssh2 with Zlib: $PROJECT_LIBSSH2_WITH_ZLIB"
echo "[$SYSTEM_PLATFORM] Component information: libssh2 without test apps: $PROJECT_LIBSSH2_WITHOUT_TEST_APPS"
echo "[$SYSTEM_PLATFORM] Component information: nghttp2 without test apps: $PROJECT_NGHTTP2_WITHOUT_TEST_APPS"
echo "[$SYSTEM_PLATFORM] Component information: OpenSSL with deprecated ciphers: $PROJECT_OPENSSL_WITH_DEPRECATED_CIPHERS"
echo "[$SYSTEM_PLATFORM] Component information: OpenSSL with shared libraries: $PROJECT_OPENSSL_WITH_SHARED_LIBRARIES"
echo "[$SYSTEM_PLATFORM] Component information: OpenSSL with shared Zlib: $PROJECT_OPENSSL_WITH_SHARED_ZLIB"
echo "[$SYSTEM_PLATFORM] Component information: OpenSSL with Zlib: $PROJECT_OPENSSL_WITH_ZLIB"
echo "[$SYSTEM_PLATFORM] Component information: OpenSSL without apps: $PROJECT_OPENSSL_WITHOUT_APPS"
echo "[$SYSTEM_PLATFORM] Component information: Zlib without test apps: $PROJECT_ZLIB_WITHOUT_TEST_APPS"



## Detect source folder
echo "[$SYSTEM_PLATFORM] Detecting $SOURCE_DIR folder ..."
if [ ! -d $SOURCE_DIR ] ; then
    echo "[$SYSTEM_PLATFORM] Detecting $SOURCE_DIR folder ... NOT FOUND"
    exit 1
fi
echo "[$SYSTEM_PLATFORM] Detecting $SOURCE_DIR folder ... FOUND"



## Create or clean temp folder
if [ ! "ON" = "$PROJECT_SHOULD_DISABLE_CLEAN_BUILD" ]; then
    echo "[$SYSTEM_PLATFORM] Cleaning $TEMP_ROOT_DIR folder ..."
    if [ -d $TEMP_ROOT_DIR ] ; then
        echo "[$SYSTEM_PLATFORM] Removing $TEMP_ROOT_DIR folder ..."
        rm -rf $TEMP_ROOT_DIR 1>/dev/null 2>&1
        MY_CHECK_RESULT=$?
        if [ $MY_CHECK_RESULT -ne 0 ] ; then
            echo "[$SYSTEM_PLATFORM] Remove $TEMP_ROOT_DIR folder ... FAILED"
            exit 1
        fi
    fi
    echo "[$SYSTEM_PLATFORM] Cleaning $TEMP_ROOT_DIR folder ... DONE"
fi
if [ ! -d $TEMP_BUILD_DIR ] ; then
    echo "[$SYSTEM_PLATFORM] Creating $TEMP_BUILD_DIR folder ..."
    mkdir -p $TEMP_BUILD_DIR 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Creating $TEMP_BUILD_DIR folder ... FAILED"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Creating $TEMP_BUILD_DIR folder ... DONE"
fi
if [ ! -d $TEMP_INSTALL_DIR ] ; then
    echo "[$SYSTEM_PLATFORM] Creating $TEMP_INSTALL_DIR folder ..."
    mkdir -p $TEMP_INSTALL_DIR 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Creating $TEMP_INSTALL_DIR folder ... FAILED"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Creating $TEMP_INSTALL_DIR folder ... DONE"
fi



## Detect CMake
echo "[$SYSTEM_PLATFORM] Detecting CMake ..."
$CMAKE_CLI --help 1>/dev/null 2>&1
MY_CHECK_RESULT=$?
if [ $MY_CHECK_RESULT -ne 0 ] ; then
    echo "[$SYSTEM_PLATFORM] Detecting CMake ... NOT FOUND"
    exit 1
fi
echo "[$SYSTEM_PLATFORM] Detecting CMake ... FOUND"



## Build project for architecture x86_64 / gnu
MY_GCC_ABI=gnu
MY_GCC_ARCH=x86_64
echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ..."
if [ "${MY_GCC_ARCH_BUILD_TOGGLE_MAP[$MY_GCC_ARCH]}" = "OFF" ] ; then
    echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... SKIPPED"
else
    # Define GCC CLI path
    MY_GCC_LIB_BASE_PATH=/usr/lib/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI
    MY_GCC_AR_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_AR_NAME
    MY_GCC_C_COMPILER_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_C_COMPILER_NAME
    MY_GCC_CXX_COMPILER_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_CXX_COMPILER_NAME
    MY_GCC_LD_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_LD_NAME

    # Detect C Compiler
    $MY_GCC_C_COMPILER_CLI --help 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... NOT FOUND"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... FOUND"

    # Detect CXX Compiler
    echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ..."
    $MY_GCC_CXX_COMPILER_CLI --help 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ... NOT FOUND"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ... FOUND"

    # Define build / install path
    MY_TEMP_BUILD_DIR=$TEMP_BUILD_DIR/$PROJECT_RELEASE_TYPE/$MY_GCC_ARCH
    mkdir -p $MY_TEMP_BUILD_DIR
    MY_TEMP_INSTALL_DIR=$TEMP_INSTALL_DIR/$PROJECT_RELEASE_TYPE/$MY_GCC_ARCH
    mkdir -p $MY_TEMP_INSTALL_DIR
    MY_TEMP_INSTALL_DIR_ABS=$(cd -- "$(${DIRNAME_CLI} "${MY_TEMP_INSTALL_DIR}/.dummy")" &> /dev/null && ${PWD_CLI})

    # Generate project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ..."
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ..."
    MY_CMAKE_ARGUMENT_LIST=(
            "-B $MY_TEMP_BUILD_DIR"
            "--install-prefix $MY_TEMP_INSTALL_DIR_ABS"
            "-DCMAKE_AR=$MY_GCC_AR_CLI"
            "-DCMAKE_C_COMPILER=$MY_GCC_C_COMPILER_CLI"
            "-DCMAKE_CXX_COMPILER=$MY_GCC_CXX_COMPILER_CLI"
            "-DCMAKE_LINKER=$MY_GCC_LD_CLI"
            "-DCMAKE_SYSTEM_PROCESSOR=$MY_GCC_ARCH"
            "-DMY_LIB_BASE_PATH=$MY_GCC_LIB_BASE_PATH"
    )
    MY_CMAKE_ARGUMENT_LIST=(${MY_CMAKE_COMMON_ARGUMENT_LIST[@]} ${MY_CMAKE_ARGUMENT_LIST[@]})
    MY_CMAKE_ARGUMENT_LIST_STRING=$(IFS=' ' eval 'echo "${MY_CMAKE_ARGUMENT_LIST[*]}"')
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... argument list:" $MY_CMAKE_ARGUMENT_LIST_STRING
    $CMAKE_CLI $MY_CMAKE_ARGUMENT_LIST_STRING
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... DONE"

    # Compile project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ..."
    $CMAKE_CLI --build $MY_TEMP_BUILD_DIR --config $PROJECT_RELEASE_TYPE
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ... DONE"

    # Install project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ..."
    $CMAKE_CLI --install $MY_TEMP_BUILD_DIR --config $PROJECT_RELEASE_TYPE
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ... DONE"
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... DONE"
fi



## Build project for architecture arm / gnueabihf
MY_GCC_ABI=gnueabihf
MY_GCC_ARCH=arm
echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ..."
if [ "${MY_GCC_ARCH_BUILD_TOGGLE_MAP[$MY_GCC_ARCH]}" = "OFF" ] ; then
    echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... SKIPPED"
else
    # Define GCC CLI path
    MY_GCC_LIB_BASE_PATH=/usr/lib/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI
    MY_GCC_AR_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_AR_NAME
    MY_GCC_C_COMPILER_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_C_COMPILER_NAME
    MY_GCC_CXX_COMPILER_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_CXX_COMPILER_NAME
    MY_GCC_LD_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_LD_NAME

    # Detect C Compiler
    $MY_GCC_C_COMPILER_CLI --help 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... NOT FOUND"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... FOUND"

    # Detect CXX Compiler
    echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ..."
    $MY_GCC_CXX_COMPILER_CLI --help 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ... NOT FOUND"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ... FOUND"

    # Define build / install path
    MY_TEMP_BUILD_DIR=$TEMP_BUILD_DIR/$PROJECT_RELEASE_TYPE/$MY_GCC_ARCH
    mkdir -p $MY_TEMP_BUILD_DIR
    MY_TEMP_INSTALL_DIR=$TEMP_INSTALL_DIR/$PROJECT_RELEASE_TYPE/$MY_GCC_ARCH
    mkdir -p $MY_TEMP_INSTALL_DIR
    MY_TEMP_INSTALL_DIR_ABS=$(cd -- "$(${DIRNAME_CLI} "${MY_TEMP_INSTALL_DIR}/.dummy")" &> /dev/null && ${PWD_CLI})

    # Generate project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ..."
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ..."
    MY_CMAKE_ARGUMENT_LIST=(
            "-B $MY_TEMP_BUILD_DIR"
            "--install-prefix $MY_TEMP_INSTALL_DIR_ABS"
            "-DCMAKE_AR=$MY_GCC_AR_CLI"
            "-DCMAKE_C_COMPILER=$MY_GCC_C_COMPILER_CLI"
            "-DCMAKE_CXX_COMPILER=$MY_GCC_CXX_COMPILER_CLI"
            "-DCMAKE_LINKER=$MY_GCC_LD_CLI"
            "-DCMAKE_SYSTEM_PROCESSOR=$MY_GCC_ARCH"
            "-DMY_LIB_BASE_PATH=$MY_GCC_LIB_BASE_PATH"
    )
    MY_CMAKE_ARGUMENT_LIST=(${MY_CMAKE_COMMON_ARGUMENT_LIST[@]} ${MY_CMAKE_ARGUMENT_LIST[@]})
    MY_CMAKE_ARGUMENT_LIST_STRING=$(IFS=' ' eval 'echo "${MY_CMAKE_ARGUMENT_LIST[*]}"')
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... argument list:" $MY_CMAKE_ARGUMENT_LIST_STRING
    $CMAKE_CLI $MY_CMAKE_ARGUMENT_LIST_STRING
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... DONE"

    # Compile project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ..."
    $CMAKE_CLI --build $MY_TEMP_BUILD_DIR --config $PROJECT_RELEASE_TYPE
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ... DONE"

    # Install project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ..."
    $CMAKE_CLI --install $MY_TEMP_BUILD_DIR --config $PROJECT_RELEASE_TYPE
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ... DONE"
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... DONE"
fi



## Build project for architecture aarch64 / gnu
MY_GCC_ABI=gnu
MY_GCC_ARCH=aarch64
echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ..."
if [ "${MY_GCC_ARCH_BUILD_TOGGLE_MAP[$MY_GCC_ARCH]}" = "OFF" ] ; then
    echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... SKIPPED"
else
    # Define GCC CLI path
    MY_GCC_LIB_BASE_PATH=/usr/lib/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI
    MY_GCC_AR_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_AR_NAME
    MY_GCC_C_COMPILER_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_C_COMPILER_NAME
    MY_GCC_CXX_COMPILER_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_CXX_COMPILER_NAME
    MY_GCC_LD_CLI=/usr/bin/$MY_GCC_ARCH-$PROJECT_GCC_OS_NAME-$MY_GCC_ABI-$PROJECT_GCC_LD_NAME

    # Detect C Compiler
    $MY_GCC_C_COMPILER_CLI --help 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... NOT FOUND"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Detecting C Compiler for $MY_GCC_ARCH ... FOUND"

    # Detect CXX Compiler
    echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ..."
    $MY_GCC_CXX_COMPILER_CLI --help 1>/dev/null 2>&1
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ... NOT FOUND"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Detecting CXX Compiler for $MY_GCC_ARCH ... FOUND"

    # Define build / install path
    MY_TEMP_BUILD_DIR=$TEMP_BUILD_DIR/$PROJECT_RELEASE_TYPE/$MY_GCC_ARCH
    mkdir -p $MY_TEMP_BUILD_DIR
    MY_TEMP_INSTALL_DIR=$TEMP_INSTALL_DIR/$PROJECT_RELEASE_TYPE/$MY_GCC_ARCH
    mkdir -p $MY_TEMP_INSTALL_DIR
    MY_TEMP_INSTALL_DIR_ABS=$(cd -- "$(${DIRNAME_CLI} "${MY_TEMP_INSTALL_DIR}/.dummy")" &> /dev/null && ${PWD_CLI})

    # Generate project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ..."
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ..."
    MY_CMAKE_ARGUMENT_LIST=(
            "-B $MY_TEMP_BUILD_DIR"
            "--install-prefix $MY_TEMP_INSTALL_DIR_ABS"
            "-DCMAKE_AR=$MY_GCC_AR_CLI"
            "-DCMAKE_C_COMPILER=$MY_GCC_C_COMPILER_CLI"
            "-DCMAKE_CXX_COMPILER=$MY_GCC_CXX_COMPILER_CLI"
            "-DCMAKE_LINKER=$MY_GCC_LD_CLI"
            "-DCMAKE_SYSTEM_PROCESSOR=$MY_GCC_ARCH"
            "-DMY_LIB_BASE_PATH=$MY_GCC_LIB_BASE_PATH"
    )
    MY_CMAKE_ARGUMENT_LIST=(${MY_CMAKE_COMMON_ARGUMENT_LIST[@]} ${MY_CMAKE_ARGUMENT_LIST[@]})
    MY_CMAKE_ARGUMENT_LIST_STRING=$(IFS=' ' eval 'echo "${MY_CMAKE_ARGUMENT_LIST[*]}"')
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... argument list:" $MY_CMAKE_ARGUMENT_LIST_STRING
    $CMAKE_CLI $MY_CMAKE_ARGUMENT_LIST_STRING
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Generating project ... DONE"

    # Compile project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ..."
    $CMAKE_CLI --build $MY_TEMP_BUILD_DIR --config $PROJECT_RELEASE_TYPE
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Compiling project ... DONE"

    # Install project
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ..."
    $CMAKE_CLI --install $MY_TEMP_BUILD_DIR --config $PROJECT_RELEASE_TYPE
    MY_CHECK_RESULT=$?
    if [ $MY_CHECK_RESULT -ne 0 ] ; then
        echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ... FAILED (ExitCode: $MY_CHECK_RESULT)"
        exit 1
    fi
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... Installing project ... DONE"
    echo "[$SYSTEM_PLATFORM] Building project for platform $MY_GCC_ARCH ... DONE"
fi
