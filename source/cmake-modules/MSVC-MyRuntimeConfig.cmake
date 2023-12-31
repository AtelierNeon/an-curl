#
#
include (CheckCCompilerFlag)
include (CheckCXXCompilerFlag)

check_c_compiler_flag (-EHsc HAS_EHSC_C)
if (HAS_EHSC_C)
  if (NOT CMAKE_C_FLAGS MATCHES "/EHsc")
    string (APPEND CMAKE_C_FLAGS " /EHsc")
  endif ()
endif ()
check_cxx_compiler_flag (-EHsc HAS_EHSC_CXX)
if (HAS_EHSC_CXX)
  if (NOT CMAKE_CXX_FLAGS MATCHES "/EHsc")
    string (APPEND CMAKE_CXX_FLAGS " /EHsc")
  endif ()
endif ()

if (BUILD_WITH_SHARED_VCRT)
  ## Presets:
  ##   Use /MD build instead of /MT to be dependent on msvcrtXXX.dll
  if (NOT CMAKE_VERSION VERSION_LESS 3.15)
    set (CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
  else ()
    foreach (flag_var
        CMAKE_C_FLAGS
        CMAKE_C_FLAGS_DEBUG
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_MINSIZEREL
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS
        CMAKE_CXX_FLAGS_DEBUG
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_CXX_FLAGS_RELWITHDEBINFO)
      if (${flag_var} MATCHES "/MT")
        string (REGEX REPLACE "/MT" "/MD" ${flag_var} "${${flag_var}}")
      endif ()
    endforeach ()
  endif ()
endif ()

if (BUILD_WITH_STATIC_VCRT)
  ## Presets:
  ##   Use /MT build instead of /MD to avoid msvcrtXXX.dll
  if (NOT CMAKE_VERSION VERSION_LESS 3.15)
    set (CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  else ()
    foreach (flag_var
        CMAKE_C_FLAGS
        CMAKE_C_FLAGS_DEBUG
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_MINSIZEREL
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS
        CMAKE_CXX_FLAGS_DEBUG
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_CXX_FLAGS_RELWITHDEBINFO)
      if (${flag_var} MATCHES "/MD")
        string (REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
      endif ()
    endforeach ()
  endif ()
endif ()

if (BUILD_WITH_WORKAROUND_OPT_GY)
  ## Presets:
  ##   Use /Gy for enabling function-level linking
  check_c_compiler_flag (-Gy HAS_GY_C)
  if (HAS_GY_C)
    if (NOT CMAKE_C_FLAGS MATCHES "/Gy")
      string (APPEND CMAKE_C_FLAGS " /Gy")
    endif ()
  endif ()
  check_cxx_compiler_flag (-Gy HAS_GY_CXX)
  if (HAS_GY_CXX)
    if (NOT CMAKE_CXX_FLAGS MATCHES "/Gy")
      string (APPEND CMAKE_CXX_FLAGS " /Gy")
    endif ()
  endif ()
endif ()

if (BUILD_WITH_WORKAROUND_SPECTRE)
  ## Presets:
  ##   Use /Qspectre for Spectre mitigation
  check_c_compiler_flag (-Qspectre HAS_QSPECTRE_C)
  if (HAS_QSPECTRE_C)
    if (NOT CMAKE_C_FLAGS MATCHES "/Qspectre")
      string (APPEND CMAKE_C_FLAGS " /Qspectre")
    endif ()
  endif ()
  check_cxx_compiler_flag (-Qspectre HAS_QSPECTRE_CXX)
  if (HAS_QSPECTRE_CXX)
    if (NOT CMAKE_CXX_FLAGS MATCHES "/Qspectre")
      string (APPEND CMAKE_CXX_FLAGS " /Qspectre")
    endif ()
  endif ()
endif ()

## Use /Z7 build instead of /Zi to avoid vcXXX.pdb
foreach (flag_var
    CMAKE_C_FLAGS
    CMAKE_C_FLAGS_DEBUG
    CMAKE_C_FLAGS_RELEASE
    CMAKE_C_FLAGS_MINSIZEREL
    CMAKE_C_FLAGS_RELWITHDEBINFO
    CMAKE_CXX_FLAGS
    CMAKE_CXX_FLAGS_DEBUG
    CMAKE_CXX_FLAGS_RELEASE
    CMAKE_CXX_FLAGS_MINSIZEREL
    CMAKE_CXX_FLAGS_RELWITHDEBINFO)
  if (${flag_var} MATCHES "/Zi")
    string (REGEX REPLACE "/Zi" "/Z7" ${flag_var} "${${flag_var}}")
  endif ()
endforeach ()
