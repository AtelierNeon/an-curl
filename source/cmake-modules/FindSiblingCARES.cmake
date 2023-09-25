if (EXISTS "${PROJECT_SOURCE_DIR}/../c-ares/include/")
  message (STATUS "Sibling c-ares found.")
  set (CARES_FOUND TRUE)
  set (CARES_INCLUDE_DIRS
    "${PROJECT_SOURCE_DIR}/../c-ares/include/"
    "${PROJECT_BINARY_DIR}/../c-ares/")
  set (CARES_LIBRARY c-ares)
  if (CARES_USE_STATIC_LIBS)
    message (STATUS "Using static sibling c-ares.")
    set (CARES_LIBRARY c-ares_static)
  else ()
    message (STATUS "Using shared sibling c-ares.")
  endif ()
  set (CARES_LIBRARIES ${CARES_LIBRARY})
else ()
  message (STATUS "Sibling c-ares NOT found.")
endif ()
