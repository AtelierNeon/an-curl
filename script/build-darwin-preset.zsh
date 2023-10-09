#!/usr/bin/env zsh

##
## Global config
##
DIRNAME_CLI=/usr/bin/dirname
PWD_CLI=/bin/pwd
UNAME_CLI=/usr/bin/uname
SYSTEM_PLATFORM=$($UNAME_CLI)

echo "[$SYSTEM_PLATFORM] Applying preset options ..."
MY_PROJECT_CARES_WITHOUT_APPS=ON
MY_PROJECT_CARES_WITHOUT_TEST_APPS=ON
MY_PROJECT_CURL_WITH_LIBSSH2=ON
MY_PROJECT_CURL_WITH_NGHTTP2=ON
MY_PROJECT_CURL_WITH_OPENSSL=ON
MY_PROJECT_CURL_WITH_ZLIB=ON
MY_PROJECT_CURL_WITHOUT_APPS=OFF
MY_PROJECT_LIBSSH2_WITH_ZLIB=ON
MY_PROJECT_LIBSSH2_WITHOUT_TEST_APPS=ON
MY_PROJECT_NGHTTP2_WITHOUT_TEST_APPS=ON
MY_PROJECT_OPENSSL_WITH_DEPRECATED_CIPHERS=ON
MY_PROJECT_OPENSSL_WITH_ZLIB=ON
MY_PROJECT_OPENSSL_WITHOUT_APPS=ON
MY_PROJECT_ZLIB_WITHOUT_TEST_APPS=ON
echo "[$SYSTEM_PLATFORM] Applying default options ... DONE"

SCRIPT_DIR=$(cd -- "$(${DIRNAME_CLI} "${BASH_SOURCE[0]:-${(%):-%x}}")" &> /dev/null && ${PWD_CLI})
source $SCRIPT_DIR/build-darwin.zsh
