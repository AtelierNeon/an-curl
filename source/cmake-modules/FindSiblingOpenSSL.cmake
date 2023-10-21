## Check which version exists and is preferred
if (EXISTS "${PROJECT_SOURCE_DIR}/../openssl-1_1_1/include/" AND BUILD_WITH_OPENSSL_1_1_1_PREFERRED)
  set (_OPENSSL_1_1_1_FOUND TRUE)
elseif (EXISTS "${PROJECT_SOURCE_DIR}/../openssl-3_0/include/" AND BUILD_WITH_OPENSSL_3_0_PREFERRED)
  set (_OPENSSL_3_0_FOUND TRUE)
else ()
  if (EXISTS "${PROJECT_SOURCE_DIR}/../openssl/include/")
    set (_OPENSSL_FOUND TRUE)
  elseif (EXISTS "${PROJECT_SOURCE_DIR}/../openssl-1_1_1/include/")
    set (_OPENSSL_1_1_1_FOUND TRUE)
  elseif (EXISTS "${PROJECT_SOURCE_DIR}/../openssl-3_0/include/")
    set (_OPENSSL_3_0_FOUND TRUE)
  endif ()
endif ()

## Use the checked version
if (_OPENSSL_1_1_1_FOUND)
  message (STATUS "Sibling OpenSSL 1.1.1 found.")
  set (OPENSSL_FOUND TRUE)
  set (OPENSSL_1_1_1_FOUND TRUE)
  set (OPENSSL_INCLUDE_DIRS
    "${PROJECT_SOURCE_DIR}/../openssl-1_1_1/include/"
    "${PROJECT_BINARY_DIR}/../openssl-1_1_1/include/")
  set (OPENSSL_CRYPTO_LIBRARY crypto)
  set (OPENSSL_SSL_LIBRARY ssl)
  set (OPENSSL_LIBRARIES
    ${OPENSSL_CRYPTO_LIBRARY}
    ${OPENSSL_SSL_LIBRARY})
elseif (_OPENSSL_3_0_FOUND)
  message (STATUS "Sibling OpenSSL 3.0 found.")
  set (OPENSSL_FOUND TRUE)
  set (OPENSSL_3_0_FOUND TRUE)
  set (OPENSSL_INCLUDE_DIRS
    "${PROJECT_SOURCE_DIR}/../openssl-3_0/include/"
    "${PROJECT_BINARY_DIR}/../openssl-3_0/include/")
  set (OPENSSL_CRYPTO_LIBRARY crypto)
  set (OPENSSL_SSL_LIBRARY ssl)
  set (OPENSSL_LIBRARIES
    ${OPENSSL_CRYPTO_LIBRARY}
    ${OPENSSL_SSL_LIBRARY})
elseif (_OPENSSL_FOUND)
  message (STATUS "Sibling OpenSSL found.")
  set (OPENSSL_FOUND TRUE)
  set (OPENSSL_INCLUDE_DIRS
    "${PROJECT_SOURCE_DIR}/../openssl/include/"
    "${PROJECT_BINARY_DIR}/../openssl/include/")
  set (OPENSSL_CRYPTO_LIBRARY crypto)
  set (OPENSSL_SSL_LIBRARY ssl)
  set (OPENSSL_LIBRARIES
    ${OPENSSL_CRYPTO_LIBRARY}
    ${OPENSSL_SSL_LIBRARY})
else ()
  message (STATUS "Sibling OpenSSL NOT found.")
endif ()

if (OPENSSL_FOUND)
  if (NOT TARGET OpenSSL::Crypto AND TARGET ${OPENSSL_CRYPTO_LIBRARY})
    add_library(OpenSSL::Crypto ALIAS ${OPENSSL_CRYPTO_LIBRARY})
  endif ()
  if (NOT TARGET OpenSSL::SSL AND TARGET ${OPENSSL_SSL_LIBRARY})
    add_library(OpenSSL::SSL ALIAS ${OPENSSL_SSL_LIBRARY})
  endif ()
endif ()

## Cleanup
unset (_OPENSSL_1_1_1_FOUND)
unset (_OPENSSL_3_0_FOUND)
unset (_OPENSSL_FOUND)
