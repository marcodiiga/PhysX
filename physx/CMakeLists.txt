cmake_minimum_required(VERSION 3.16)
project(PhysX VERSION 4.1.2 LANGUAGES C CXX)

# Define PhysX root directory if not already defined
if(NOT DEFINED PHYSX_ROOT_DIR)
    set(PHYSX_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "Path to PhysX root directory")
endif()

# Export environment variable for child processes
set(ENV{PHYSX_ROOT_DIR} ${PHYSX_ROOT_DIR})

# Set up module paths
set(PHYSX_CMAKE_MODULES_PATH ${PHYSX_ROOT_DIR}/source/compiler/cmake/modules CACHE INTERNAL "")
list(APPEND CMAKE_MODULE_PATH ${PHYSX_CMAKE_MODULES_PATH})

# PhysX build options
option(PX_BUILDSNIPPETS "Generate the snippets" OFF)
option(PX_BUILDPVDRUNTIME "Generate the OmniPVD project" OFF)
option(PX_CMAKE_SUPPRESS_REGENERATION "Disable zero_check projects" OFF)
option(PX_GENERATE_GPU_PROJECTS "Generate the GPU projects, if possible." ON)
option(PX_GENERATE_GPU_PROJECTS_ONLY "Generate ONLY the GPU projects, if possible." OFF)

# Output compile commands
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enable folder properties
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Platform detection and configuration
if(WIN32)
    set(TARGET_BUILD_PLATFORM "windows" CACHE INTERNAL "")
    set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "")
elseif(APPLE)
    set(TARGET_BUILD_PLATFORM "mac" CACHE INTERNAL "")
    set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "")
elseif(UNIX AND NOT APPLE)
    set(TARGET_BUILD_PLATFORM "linux" CACHE INTERNAL "")
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
        set(PX_OUTPUT_ARCH "arm" CACHE INTERNAL "")
    else()
        set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "")
    endif()
endif()

# Catch unsupported platforms
if(NOT DEFINED TARGET_BUILD_PLATFORM)
    message(FATAL_ERROR "Unsupported platform")
endif()

message(STATUS "Target platform: ${TARGET_BUILD_PLATFORM}")
message(STATUS "Target architecture: ${PX_OUTPUT_ARCH}")

# Set output directories
set(PX_OUTPUT_LIB_DIR "${PHYSX_ROOT_DIR}/lib" CACHE PATH "")
set(PX_OUTPUT_BIN_DIR "${PHYSX_ROOT_DIR}/bin" CACHE PATH "")
set(PX_OUTPUT_DLL_DIR "${PHYSX_ROOT_DIR}/bin" CACHE PATH "")

# Always enable CUDA for the main PhysX library to support GPU acceleration
if(NOT CMAKE_CROSSCOMPILING AND (TARGET_BUILD_PLATFORM STREQUAL "windows" OR TARGET_BUILD_PLATFORM STREQUAL "linux"))
    set(PX_GENERATE_GPU_PROJECTS ON CACHE BOOL "Generate the GPU projects" FORCE)
    enable_language(CUDA)
    find_package(CUDAToolkit REQUIRED)

    if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
        set(CMAKE_CUDA_ARCHITECTURES 75)
    endif()

    message(STATUS "CUDA enabled with architecture ${CMAKE_CUDA_ARCHITECTURES}")
endif()

# Include FetchContent module for dependencies
include(FetchContent)

# Set up dependencies using FetchContent
message(STATUS "Setting up dependencies...")

# Only declare and fetch dependencies if we're the main project
# This prevents redundant dependency fetching when included via FetchContent
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    # 1. RapidJSON
    FetchContent_Declare(
        rapidjson
        GIT_REPOSITORY https://github.com/Tencent/rapidjson.git
        GIT_TAG v1.1.0
    )
    FetchContent_MakeAvailable(rapidjson)
    message(STATUS "RapidJSON available at: ${rapidjson_SOURCE_DIR}")
endif()

# 2. Platform-specific dependencies
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    if(TARGET_BUILD_PLATFORM STREQUAL "windows")
        # Clang for metadata generation
        FetchContent_Declare(
            clangMetadata
            GIT_REPOSITORY https://github.com/AstroVPK/LLVM-4.0.0.git
            GIT_TAG master  # Closest available to 4.0.0
        )

        # VSWhere for Windows
        FetchContent_Declare(
            vswhere
            GIT_REPOSITORY https://github.com/microsoft/vswhere.git
            GIT_TAG 2.8.4  # Close to requested 2.7.3
        )

        # FreeGLUT for Windows
        FetchContent_Declare(
            freeglut
            GIT_REPOSITORY https://github.com/freeglut/freeglut.git
            GIT_TAG v3.4.0  # Closest to requested 3.4
        )

        FetchContent_MakeAvailable(clangMetadata vswhere freeglut)
        message(STATUS "VSWhere available at: ${vswhere_SOURCE_DIR}")
        message(STATUS "FreeGLUT available at: ${freeglut_SOURCE_DIR}")

    elseif(TARGET_BUILD_PLATFORM STREQUAL "linux")
        # OpenGL for Linux
        find_package(OpenGL REQUIRED)
        message(STATUS "OpenGL found: ${OPENGL_FOUND}")

        # Clang for Linux
        FetchContent_Declare(
            clangMetadata
            GIT_REPOSITORY https://github.com/AstroVPK/LLVM-4.0.0.git
            GIT_TAG master  # Closest available to 4.0.0
        )
        FetchContent_MakeAvailable(clangMetadata)
    endif()
endif()

# Set public release flag
set(PUBLIC_RELEASE 1 CACHE INTERNAL "")

# Disable zero_check projects if requested
if(PX_CMAKE_SUPPRESS_REGENERATION)
    set(CMAKE_SUPPRESS_REGENERATION true)
endif()

# Create interface library for client projects
add_library(physx_lib INTERFACE)

# Add PhysX SDK Source code to the build
message(STATUS "Adding PhysX SDK source...")
add_subdirectory(${PHYSX_ROOT_DIR}/source/compiler/cmake ${CMAKE_CURRENT_BINARY_DIR}/sdk_source_bin)

# Always add GPU source - required for GPU acceleration and CUDA context manager
message(STATUS "Adding PhysX GPU source...")
add_subdirectory(${PHYSX_ROOT_DIR}/source/compiler/cmakegpu ${CMAKE_CURRENT_BINARY_DIR}/sdk_gpu_source_bin)

# Add PVD runtime if requested
if(PX_BUILDPVDRUNTIME)
    if(TARGET_BUILD_PLATFORM STREQUAL "windows" OR TARGET_BUILD_PLATFORM STREQUAL "linux")
        message(STATUS "Adding PVD Runtime...")
        add_subdirectory(${PHYSX_ROOT_DIR}/pvdruntime/compiler/cmake ${CMAKE_CURRENT_BINARY_DIR}/pvdruntime_bin)
    endif()
endif()

# Add snippets if requested
if(PX_BUILDSNIPPETS)
    message(STATUS "Adding Snippets...")
    add_subdirectory(${PHYSX_ROOT_DIR}/snippets/compiler/cmake ${CMAKE_CURRENT_BINARY_DIR}/sdk_snippets_bin)
endif()

# Link against required PhysX libraries
# Check if targets exist before linking to handle various build configurations
set(PHYSX_LIBS "")
foreach(lib IN ITEMS PhysX PhysXCommon PhysXFoundation PhysXExtensions PhysXPvdSDK PhysXCooking PhysXCharacterKinematic PhysXVehicle)
    if(TARGET ${lib})
        message(STATUS "Linking physx_lib with ${lib}")
        target_link_libraries(physx_lib INTERFACE ${lib})
        list(APPEND PHYSX_LIBS ${lib})
    endif()
endforeach()

# Include necessary directories
target_include_directories(physx_lib INTERFACE
    ${PHYSX_ROOT_DIR}/include
    ${PHYSX_ROOT_DIR}/source/foundation/include
    ${PHYSX_ROOT_DIR}/source/physx/include
    ${PHYSX_ROOT_DIR}/source/common/include
)

# Export all compile definitions from PhysX targets to consuming projects
foreach(lib IN LISTS PHYSX_LIBS)
    get_target_property(DEFS ${lib} INTERFACE_COMPILE_DEFINITIONS)
    if(DEFS)
        target_compile_definitions(physx_lib INTERFACE ${DEFS})
    endif()

    get_target_property(OPTS ${lib} INTERFACE_COMPILE_OPTIONS)
    if(OPTS)
        target_compile_options(physx_lib INTERFACE ${OPTS})
    endif()

    get_target_property(FEATS ${lib} INTERFACE_COMPILE_FEATURES)
    if(FEATS)
        target_compile_features(physx_lib INTERFACE ${FEATS})
    endif()
endforeach()

# PhysX CMake configuration complete
message(STATUS "PhysX CMake configuration complete")
