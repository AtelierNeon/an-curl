# Based on original work by David Manura
# Copyright (C) 2007-2012 LuaDist.
# Copyright (C) 2013 Brian Sidebotham
# Copyright (C) 2016-2019 Jean-Luc Barriere

# Redistribution and use of this file is allowed according to the terms of the
# MIT license.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set( CMAKE_LEGACY_CYGWIN_WIN32 0 )
project( openssl
  DESCRIPTION "OpenSSL" )
cmake_minimum_required( VERSION 3.1.0...3.15.0 )

option( OPENSSL_WITH_DEPRECATED_CIPHERS "Build OpenSSL with deprecated ciphers." OFF )
option( OPENSSL_WITH_SHARED_LIBRARIES "Build shared version of the libcrypto/libssl libraries." OFF )
option( OPENSSL_WITH_SHARED_ZLIB "Build OpenSSL with shared version of Zlib." OFF )
option( OPENSSL_WITH_ZLIB "Build OpenSSL with Zlib." OFF )
option( OPENSSL_WITHOUT_APPS "Build OpenSSL without apps." OFF )

set( BUILD_SHARED_LIBS ${OPENSSL_WITH_SHARED_LIBRARIES} )

set( CMAKE_DISABLE_SOURCE_CHANGES ON )
set( CMAKE_DISABLE_IN_SOURCE_BUILD ON )

list( APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" )

option( WITH_APPS "Build applications" ON )
if( OPENSSL_WITHOUT_APPS )
  set( WITH_APPS OFF )
endif()

# OpenSSL version detection

file( STRINGS "${PROJECT_SOURCE_DIR}/VERSION.dat" openssl_version_major
  REGEX "^MAJOR=([0-9])+" )
file( STRINGS "${PROJECT_SOURCE_DIR}/VERSION.dat" openssl_version_minor
  REGEX "^MINOR=([0-9])+" )
file( STRINGS "${PROJECT_SOURCE_DIR}/VERSION.dat" openssl_version_patch
  REGEX "^PATCH=([0-9])+" )
file( STRINGS "${PROJECT_SOURCE_DIR}/VERSION.dat" openssl_release_date
  REGEX "^RELEASE_DATE=.+")

string( REPLACE "MAJOR=" "" OPENSSL_VERSION_MAJOR ${openssl_version_major} )
string( REPLACE "MINOR=" "" OPENSSL_VERSION_MINOR ${openssl_version_minor} )
string( REPLACE "PATCH=" "" OPENSSL_VERSION_PATCH ${openssl_version_patch} )
string( REPLACE "RELEASE_DATE=" "" OPENSSL_RELEASE_DATE ${openssl_release_date} )
string( REPLACE "\"" "" OPENSSL_RELEASE_DATE ${OPENSSL_RELEASE_DATE} )

set( OPENSSL_VERSION "${OPENSSL_VERSION_MAJOR}.${OPENSSL_VERSION_MINOR}.${OPENSSL_VERSION_PATCH}" )

message( STATUS "OpenSSL version ${OPENSSL_VERSION}" )

set( VERSION_MAJOR ${OPENSSL_VERSION_MAJOR} )
set( VERSION_MINOR ${OPENSSL_VERSION_MINOR} )
set( VERSION_PATCH ${OPENSSL_VERSION_PATCH} )
set( RELEASE_DATE ${OPENSSL_RELEASE_DATE} )

set( VERSION_STRING ${OPENSSL_VERSION} )
set( LIB_VERSION ${VERSION_MAJOR}.${VERSION_MINOR} )
set( LIB_SOVERSION ${VERSION_MAJOR}.${VERSION_MINOR} )

add_definitions( -DOPENSSL_NO_ASM )
add_definitions( -DOPENSSL_NO_STATIC_ENGINE )

if( OPENSSL_WITH_SHARED_ZLIB )
  set( OPENSSL_WITH_ZLIB ON )
endif()
if( OPENSSL_WITH_ZLIB AND NOT OPENSSL_WITH_SHARED_ZLIB )
  set(ZLIB_USE_STATIC_LIBS ON)
endif()
find_package( SiblingZLIB )
if( NOT ZLIB_FOUND )
  find_package( ZLIB )
endif()

if( MSVC )
  include( MSVCRuntime )
  configure_msvc_runtime()
  set( OPENSSLDIR "C:/ProgramData/openssl/ssl" )
  set( ENGINESDIR "C:/ProgramData/openssl/engines-3" )
  set( MODULESDIR "C:/ProgramData/openssl/ossl-modules" )
else()
  set( OPENSSLDIR "${CMAKE_INSTALL_PREFIX}/ssl" )
  set( ENGINESDIR "${CMAKE_INSTALL_PREFIX}/engines-3" )
  set( MODULESDIR "${CMAKE_INSTALL_PREFIX}/ossl-modules" )
endif()
add_definitions( "-DOPENSSLDIR=\"${OPENSSLDIR}\"" )
add_definitions( "-DENGINESDIR=\"${ENGINESDIR}\"" )
add_definitions( "-DMODULESDIR=\"${MODULESDIR}\"" )

if( APPLE )
  set( CMAKE_MACOSX_RPATH ON )
  add_definitions( -DOPENSSL_SYSNAME_MACOSX )
endif()

if( WIN32 )
  set( CMAKE_SHARED_LIBRARY_PREFIX "lib" )
  set( CMAKE_STATIC_LIBRARY_PREFIX "lib" )
else()
  set( CMAKE_POSITION_INDEPENDENT_CODE ON )
endif()

if( WIN32 AND NOT CYGWIN )
  add_definitions( -DOPENSSL_SYSNAME_WIN32 )
  add_definitions( -DWIN32_LEAN_AND_MEAN )
  add_definitions( -D_CRT_SECURE_NO_WARNINGS )

  if(BUILD_SHARED_LIBS)
    # avoid conflict: ocsp.h and wincrypt.h
    add_definitions( -D_WINDLL )
  endif()
endif()

if( MINGW )
  set( CMAKE_SHARED_LINKER_FLAGS "-Wl,--export-all" )
endif()

include( CheckTypeSize )
check_type_size( "long" LONG_INT )
check_type_size( "long long" LONG_LONG_INT )
check_type_size( "int" INT )
if( HAVE_LONG_INT AND (${LONG_INT} EQUAL 8) )
  set( SIXTY_FOUR_BIT_LONG ON )
elseif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  set( SIXTY_FOUR_BIT ON )
else()
  set( THIRTY_TWO_BIT ON )
endif()

if( MSVC OR ( WIN32 AND MINGW AND NOT CYGWIN ) )
  set( OPENSSL_EXPORT_VAR_AS_FUNCTION 1 )
endif()

# Begin configure public headers
file( COPY ${PROJECT_SOURCE_DIR}/include/internal DESTINATION include )
file( COPY ${PROJECT_SOURCE_DIR}/include/crypto DESTINATION include )
file( COPY ${PROJECT_SOURCE_DIR}/include/openssl DESTINATION include )

configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/asn1.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/asn1.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/asn1t.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/asn1t.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/bio.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/bio.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/cmp.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/cmp.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/cms.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/cms.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/conf.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/conf.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/crmf.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/crmf.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/crypto.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/crypto.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/ct.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/ct.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/ess.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/ess.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/err.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/err.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/fipskey.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/fipskey.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/lhash.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/lhash.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/ocsp.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/ocsp.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/opensslv.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/opensslv.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/pkcs12.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/pkcs12.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/pkcs7.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/pkcs7.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/safestack.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/safestack.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/ssl.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/ssl.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/srp.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/srp.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/ui.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/ui.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/x509.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/x509.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/x509v3.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/x509v3.h )
configure_file( ${PROJECT_SOURCE_DIR}/include/openssl/x509_vfy.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/x509_vfy.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_digests.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_digests.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_dsa.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_dsa.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_ec.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_ec.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_ecx.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_ecx.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_rsa.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_rsa.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_sm2.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_sm2.h )
configure_file( ${PROJECT_SOURCE_DIR}/providers/common/include/prov/der_wrap.h.cmake
  ${PROJECT_BINARY_DIR}/providers/common/include/prov/der_wrap.h )

file( READ ${PROJECT_SOURCE_DIR}/include/openssl/configuration.h.cmake CONF )
set( CONF "
#define OPENSSL_NO_EC_NISTP_64_GCC_128
${CONF}" )
if( NOT OPENSSL_WITH_DEPRECATED_CIPHERS )
set( CONF "
#define OPENSSL_NO_MD2
#define OPENSSL_NO_RC5
#define OPENSSL_NO_SSL3
#define OPENSSL_NO_SSL3_METHOD
${CONF}" )
endif()
if( OPENSSL_WITH_ZLIB AND ZLIB_FOUND )
set( CONF "
#define ZLIB
${CONF}" )
endif()
if( WIN32 OR APPLE )
set( CONF "
#define OPENSSL_NO_KTLS
${CONF}" )
endif()
file( WRITE ${PROJECT_BINARY_DIR}/include/openssl/configuration.h.cmake "${CONF}" )
configure_file( ${PROJECT_BINARY_DIR}/include/openssl/configuration.h.cmake
  ${PROJECT_BINARY_DIR}/include/openssl/configuration.h )
# End configure public headers

add_subdirectory(crypto)
add_subdirectory(ssl)

if( WITH_APPS AND NOT ANDROID AND NOT IOS )
  add_subdirectory(apps)

  file( READ ${PROJECT_SOURCE_DIR}/c_rehash.cmake C_REHASH )
  string( REPLACE "@OPENSSLDIR@" "${OPENSSLDIR}" C_REHASH "${C_REHASH}" )
  string( REPLACE "@CMAKE_INSTALL_PREFIX@" "${CMAKE_INSTALL_PREFIX}" C_REHASH "${C_REHASH}" )
  file( WRITE ${PROJECT_BINARY_DIR}/c_rehash "${C_REHASH}" )

  install( FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/apps/openssl.cnf
    ${CMAKE_CURRENT_SOURCE_DIR}/apps/ct_log_list.cnf
    DESTINATION ssl )
  install( CODE "FILE(MAKE_DIRECTORY \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/ssl/certs)" )
  install( CODE "FILE(MAKE_DIRECTORY \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/ssl/misc)" )
  install( CODE "FILE(MAKE_DIRECTORY \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/ssl/private)" )
  install( FILES ${PROJECT_BINARY_DIR}/c_rehash DESTINATION bin )
endif()

file( GLOB PUBLIC_HEADERS "${PROJECT_BINARY_DIR}/include/openssl/*.h" )
install( FILES ${PUBLIC_HEADERS} DESTINATION include/openssl )

install( FILES
  FAQ.md LICENSE.txt README.md README-ENGINES.md
  DESTINATION share/openssl )

install( DIRECTORY doc DESTINATION share )

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY
)

if( ${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME} )
  add_custom_target(
    "uninstall"
    ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
  )
endif()

# Generate the package target
set( CPACK_GENERATOR ZIP TGZ )
set( CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}" )
set( CPACK_PACKAGE_VERSION_MAJOR ${VERSION_MAJOR} )
set( CPACK_PACKAGE_VERSION_MINOR ${VERSION_MINOR} )
set( CPACK_PACKAGE_VERSION_PATCH ${VERSION_PATCH} )
set( CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${VERSION_STRING}" )

include( CPack )
