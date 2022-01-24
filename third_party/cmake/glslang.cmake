find_package(Python3 COMPONENTS Interpreter)

set(SKIP_GLSLANG_INSTALL OFF CACHE BOOL "")
set(ENABLE_GLSLANG_WEB OFF CACHE BOOL "")
set(BUILD_TESTING OFF CACHE BOOL "")
set(ENABLE_OPT ON CACHE BOOL "")
set(INSTALL_GTEST OFF CACHE BOOL "")

set(GLSLANG_NAME glslang)
set(GLSLANG_VERSION 7.12.3352)
set(GLSLANG_TAR_NAME ${GLSLANG_NAME}-${GLSLANG_VERSION}.tar.gz)
set(GLSLANG_DOWNLOAD_PATH ${CMAKE_BINARY_DIR}/downloads)
set(GLSLANG_URL https://github.com/KhronosGroup/glslang/archive/${GLSLANG_VERSION}.tar.gz)
set(GLSLANG_TARBAL_PATH ${CMAKE_BINARY_DIR}/downloads/${GLSLANG_TAR_NAME})
set(GLSLANG_EXTRACT_PATH ${CMAKE_BINARY_DIR}/downloads)

if(NOT EXISTS ${GLSLANG_DOWNLOAD_PATH})
    file(MAKE_DIRECTORY ${GLSLANG_DOWNLOAD_PATH})
endif()

if(NOT EXISTS ${GLSLANG_DOWNLOAD_PATH}/${GLSLANG_TAR_NAME})
    message(STATUS "Downloading glslang tarball")
    file(DOWNLOAD ${GLSLANG_URL} ${GLSLANG_DOWNLOAD_PATH}/${GLSLANG_TAR_NAME})
endif()

if(NOT EXISTS ${GLSLANG_EXTRACT_PATH}/${GLSLANG_NAME}-${GLSLANG_VERSION})
    message(STATUS "Extracting glslang tarball")
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar xf ${GLSLANG_TARBAL_PATH}
        WORKING_DIRECTORY ${GLSLANG_EXTRACT_PATH}
        RESULT_VARIABLE GLSLANG_EXTRACT_SUCCESS
        OUTPUT_QUIET)

    message(STATUS "Updating glslang git dependencies")
    execute_process(COMMAND ${Python3_EXECUTABLE} update_glslang_sources.py
        WORKING_DIRECTORY ${GLSLANG_EXTRACT_PATH}/${GLSLANG_NAME}-${GLSLANG_VERSION}
        RESULT_VARIABLE GLSLANG_UPDATE_SUCCESS
        OUTPUT_QUIET
        ERROR_QUIET)

    if(GLSLANG_UPDATE_SUCCESS EQUAL "1")
        message(FATAL_ERROR "Failed to update glslang dependencies")
    endif()

endif()

set(GLSLANG_PATH ${CMAKE_BINARY_DIR}/downloads/${GLSLANG_NAME}-${GLSLANG_VERSION})
set(GLSLANG_INSTALL_DIR ${CMAKE_BINARY_DIR}/downloads/${GLSLANG_NAME}-${GLSLANG_VERSION} CACHE STRING "Tell vulkan loader where glslang is installed")