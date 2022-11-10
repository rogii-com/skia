if(TARGET skia::library)
   return()
endif()

add_library(
    skia::library
    SHARED
    IMPORTED
)

add_definitions(-DSK_GL)

if(MSVC)
    set_target_properties(
        skia::library
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/bin/release/skia.dll"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/bin/debug/skia.dll"
            IMPORTED_IMPLIB
                "${CMAKE_CURRENT_LIST_DIR}/lib/release/skia.dll.lib"
            IMPORTED_IMPLIB_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/debug/skia.dll.lib"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/;${CMAKE_CURRENT_LIST_DIR}/include/"
    )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        skia::library
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/release/libskia.so"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/debug/libskia.so"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/;${CMAKE_CURRENT_LIST_DIR}/include/"
    )
endif()

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_skia
    CNPM_RUNTIME
)

foreach(COMPONENT_NAME ${COMPONENT_NAMES})
    install(
        FILES
            $<TARGET_FILE:skia::library>
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
endforeach()