cmake_minimum_required(VERSION 3.16)
project(PhysX VERSION 5.6.0 LANGUAGES C CXX CUDA)

# Installation helper functions
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Set PHYSX_ROOT_DIR to the location of this file
set(PHYSX_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "Path to PhysX root directory")
set(PHYSX_CMAKE_MODULES_PATH "${PHYSX_ROOT_DIR}/source/compiler/cmake/modules" CACHE INTERNAL "")
list(APPEND CMAKE_MODULE_PATH ${PHYSX_CMAKE_MODULES_PATH})

# Mimic Python preset parameters via options and environment variables
option(PX_GENERATE_GPU_PROJECTS "Generate GPU projects" ON)
option(PX_GENERATE_GPU_PROJECTS_ONLY "Generate ONLY GPU projects" OFF)
option(PX_BUILDSNIPPETS "Generate the snippets" OFF)
option(PX_BUILDPVDRUNTIME "Generate the OmniPVD project" OFF)
option(PX_CMAKE_SUPPRESS_REGENERATION "Disable zero_check projects" OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Installation control
if(PROJECT_IS_TOP_LEVEL)
  set(PX_IS_TOP_LEVEL_PROJECT TRUE)
  set(PX_ENABLE_INSTALL TRUE)
else()
  set(PX_IS_TOP_LEVEL_PROJECT FALSE)
  set(PX_ENABLE_INSTALL FALSE)
  set(PX_BUILDSNIPPETS FALSE)
  set(PX_BUILDPVDRUNTIME FALSE)

  # force PhysX to output libs into the top project's build folder instead of its own source folder
  set(PX_OUTPUT_LIB_DIR "${CMAKE_BINARY_DIR}/physx" CACHE PATH "" FORCE)
  set(PX_OUTPUT_BIN_DIR "${CMAKE_BINARY_DIR}/physx" CACHE PATH "" FORCE)
endif()

# Allow overriding some parameters from the command line for preset-like behavior.
if(NOT DEFINED TARGET_BUILD_PLATFORM)
  if(WIN32)
    set(TARGET_BUILD_PLATFORM "windows" CACHE INTERNAL "Target build platform")
  elseif(APPLE)
    set(TARGET_BUILD_PLATFORM "mac" CACHE INTERNAL "Target build platform")
  elseif(UNIX)
    set(TARGET_BUILD_PLATFORM "linux" CACHE INTERNAL "Target build platform")
  endif()
endif()

if(NOT DEFINED PX_OUTPUT_ARCH)
  if(TARGET_BUILD_PLATFORM STREQUAL "windows" OR TARGET_BUILD_PLATFORM STREQUAL "mac")
    set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "Output architecture")
  elseif(TARGET_BUILD_PLATFORM STREQUAL "linux")
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
      set(PX_OUTPUT_ARCH "arm" CACHE INTERNAL "Output architecture")
    else()
      set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "Output architecture")
    endif()
  endif()
endif()

# Allow defining the compiler and generator from the command-line (mimicking preset xml)
if(NOT DEFINED COMPILER)
  set(COMPILER "" CACHE STRING "Preset compiler")
endif()
if(NOT DEFINED GENERATOR)
  set(GENERATOR "" CACHE STRING "Preset generator")
endif()

message(STATUS "Target platform: ${TARGET_BUILD_PLATFORM}")
message(STATUS "Output architecture: ${PX_OUTPUT_ARCH}")
message(STATUS "Compiler: ${COMPILER}")
message(STATUS "Generator: ${GENERATOR}")

# Toolchain and compiler configuration (exactly as in the Python script's getPlatformCMakeParams)
if(TARGET_BUILD_PLATFORM STREQUAL "win64")
  if(COMPILER STREQUAL "x86_64-w64-mingw32-g++")
    set(CMAKE_TOOLCHAIN_FILE "${PHYSX_CMAKE_MODULES_PATH}/linux/WindowsCrossToolchain.linux-unknown-x86_64.cmake"
         CACHE FILEPATH "Toolchain file")
  endif()
elseif(TARGET_BUILD_PLATFORM STREQUAL "linux")
  if(COMPILER STREQUAL "clang-crosscompile")
    set(CMAKE_TOOLCHAIN_FILE "${PHYSX_CMAKE_MODULES_PATH}/linux/LinuxCrossToolchain.x86_64-unknown-linux-gnu.cmake"
         CACHE FILEPATH "Toolchain file")
    if(DEFINED ENV{PM_MinGW_PATH})
      set(CMAKE_MAKE_PROGRAM "$ENV{PM_MinGW_PATH}/bin/mingw32-make.exe")
    endif()
  elseif(COMPILER STREQUAL "clang")
    if(DEFINED ENV{PM_clang_PATH})
      set(CMAKE_C_COMPILER "$ENV{PM_clang_PATH}/bin/clang")
      set(CMAKE_CXX_COMPILER "$ENV{PM_clang_PATH}/bin/clang++")
    endif()
  endif()
elseif(TARGET_BUILD_PLATFORM STREQUAL "linuxAarch64")
  if(COMPILER STREQUAL "clang-crosscompile")
    set(CMAKE_TOOLCHAIN_FILE "${PHYSX_CMAKE_MODULES_PATH}/linux/LinuxCrossToolchain.aarch64-unknown-linux-gnueabihf.cmake"
         CACHE FILEPATH "Toolchain file")
    if(DEFINED ENV{PM_MinGW_PATH})
      set(CMAKE_MAKE_PROGRAM "$ENV{PM_MinGW_PATH}/bin/mingw32-make.exe")
    endif()
  elseif(COMPILER STREQUAL "gcc")
    # Optionally adjust settings for Packman's compiler here.
    # ...additional configuration if needed...
  elseif(COMPILER STREQUAL "clang")
    if(DEFINED ENV{PM_clang_PATH})
      set(CMAKE_C_COMPILER "$ENV{PM_clang_PATH}/bin/clang")
      set(CMAKE_CXX_COMPILER "$ENV{PM_clang_PATH}/bin/clang++")
    endif()
  endif()
endif()

# Common parameters (like the Python getCommonParams)
set(CMAKE_PREFIX_PATH "$ENV{PM_PATHS}" CACHE STRING "CMake prefix path")
add_definitions(-DPHYSX_ROOT_DIR="${PHYSX_ROOT_DIR}")
add_definitions(-DPX_OUTPUT_LIB_DIR="${PHYSX_ROOT_DIR}")
add_definitions(-DPX_OUTPUT_BIN_DIR="${PHYSX_ROOT_DIR}")

if(DEFINED ENV{GENERATE_SOURCE_DISTRO} AND "$ENV{GENERATE_SOURCE_DISTRO}" STREQUAL "1")
  add_definitions(-DPX_GENERATE_SOURCE_DISTRO=1)
endif()

# CUDA Integration (mimicking GPU-related switches from Python)
if(NOT CMAKE_CROSSCOMPILING AND (TARGET_BUILD_PLATFORM STREQUAL "windows" OR TARGET_BUILD_PLATFORM STREQUAL "linux"))
  set(PX_GENERATE_GPU_PROJECTS ON CACHE BOOL "Force GPU projects" FORCE)
  enable_language(CUDA)
  find_package(CUDAToolkit REQUIRED)
  if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES 75 CACHE STRING "CUDA architectures")
  endif()
  message(STATUS "CUDA enabled with architecture ${CMAKE_CUDA_ARCHITECTURES}")
  if(DEFINED ENV{PM_CUDA_PATH})
    # Use the toolchain adjustments noted in the Python script
    set(CUDAToolkit_ROOT_DIR "$ENV{PM_CUDA_PATH}")
    message(STATUS "Using CUDA Toolkit at: $ENV{PM_CUDA_PATH}")
    if((COMPILER STREQUAL "vc15" OR COMPILER STREQUAL "vc16" OR COMPILER STREQUAL "vc17") AND NOT GENERATOR STREQUAL "ninja")
      # Additional CUDA flags could be passed here if required.
    elseif(COMPILER STREQUAL "clang" AND DEFINED ENV{PM_clang_PATH})
      set(CMAKE_CUDA_HOST_COMPILER "$ENV{PM_clang_PATH}/bin/clang++")
    endif()
  endif()
endif()

# Platform auto-detection fallback (if not preset)
if(WIN32)
  set(TARGET_BUILD_PLATFORM "windows" CACHE INTERNAL "Platform")
  set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "Architecture")
elseif(APPLE)
  set(TARGET_BUILD_PLATFORM "mac" CACHE INTERNAL "Platform")
  set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "Architecture")
elseif(UNIX AND NOT APPLE)
  set(TARGET_BUILD_PLATFORM "linux" CACHE INTERNAL "Platform")
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    set(PX_OUTPUT_ARCH "arm" CACHE INTERNAL "Architecture")
  else()
    set(PX_OUTPUT_ARCH "x86" CACHE INTERNAL "Architecture")
  endif()
endif()
message(STATUS "Final configuration - Platform: ${TARGET_BUILD_PLATFORM}, Arch: ${PX_OUTPUT_ARCH}")

# Set output directories
set(PX_OUTPUT_LIB_DIR "${PHYSX_ROOT_DIR}/lib" CACHE PATH "")
set(PX_OUTPUT_BIN_DIR "${PHYSX_ROOT_DIR}/bin" CACHE PATH "")
set(PX_OUTPUT_DLL_DIR "${PHYSX_ROOT_DIR}/bin" CACHE PATH "")

# Dependencies and FetchContent integration (as before)
include(FetchContent)
message(STATUS "Setting up dependencies...")

# 1. RapidJSON - properly handle fetch without installation issues
FetchContent_Declare(
    rapidjson
    GIT_REPOSITORY https://github.com/Tencent/rapidjson.git
    GIT_TAG v1.1.0
)

# Only populate source, don't do project configuration to avoid install rules
FetchContent_GetProperties(rapidjson)
if(NOT rapidjson_POPULATED)
  message(STATUS "Fetching RapidJSON...")
  FetchContent_Populate(rapidjson)
endif()

# Create our own interface target for RapidJSON
add_library(rapidjson INTERFACE)
target_include_directories(rapidjson INTERFACE ${rapidjson_SOURCE_DIR}/include)
add_library(RapidJSON::rapidjson ALIAS rapidjson)

message(STATUS "RapidJSON available at: ${rapidjson_SOURCE_DIR}")

# 2. Platform-specific dependencies
if(TARGET_BUILD_PLATFORM STREQUAL "windows" AND PX_ENABLE_INSTALL)
  add_custom_command(
      OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/generated_metadata.h
      COMMAND echo "// Minimal metadata" > ${CMAKE_CURRENT_BINARY_DIR}/generated_metadata.h
      COMMENT "Generating dummy metadata"
  )
  add_custom_target(physx_metadata DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/generated_metadata.h)
  FetchContent_Declare(
      vswhere
      GIT_REPOSITORY https://github.com/microsoft/vswhere.git
      GIT_TAG 2.8.4
  )
  FetchContent_Declare(
      freeglut
      GIT_REPOSITORY https://github.com/freeglut/freeglut.git
      GIT_TAG v3.4.0
  )
  set(FREEGLUT_BUILD_DEMOS OFF CACHE BOOL "Build FreeGLUT demos" FORCE)
  set(FREEGLUT_BUILD_SHARED_LIBS ON CACHE BOOL "Build FreeGLUT shared library" FORCE)
  set(FREEGLUT_BUILD_STATIC_LIBS OFF CACHE BOOL "Build FreeGLUT static library" FORCE)
  FetchContent_MakeAvailable(vswhere freeglut)
  message(STATUS "VSWhere and FreeGLUT available")
elseif(TARGET_BUILD_PLATFORM STREQUAL "linux")
  find_package(OpenGL REQUIRED)
  message(STATUS "OpenGL found: ${OPENGL_FOUND}")
endif()

set(PUBLIC_RELEASE 1 CACHE INTERNAL "")
if(PX_CMAKE_SUPPRESS_REGENERATION)
  set(CMAKE_SUPPRESS_REGENERATION true)
endif()

# Create interface library for clients
add_library(physx_lib INTERFACE)
add_dependencies(physx_lib physx_metadata)

# Add PhysX source directories
message(STATUS "Adding PhysX SDK source...")
add_subdirectory(${PHYSX_ROOT_DIR}/source/compiler/cmake ${CMAKE_CURRENT_BINARY_DIR}/sdk_source_bin)
message(STATUS "Adding PhysX GPU source...")
add_subdirectory(${PHYSX_ROOT_DIR}/source/compiler/cmakegpu ${CMAKE_CURRENT_BINARY_DIR}/sdk_gpu_source_bin)

if(WIN32)
  # Prevent the duplicate "_64" on windows platforms by clearing the auto-appended postfixes
  set_target_properties(PhysXGpu PROPERTIES
    DEBUG_POSTFIX   ""
    RELEASE_POSTFIX ""
    PROFILE_POSTFIX ""
    CHECKED_POSTFIX ""
  )

  # If you still want “_64” to appear exactly once:
  #   Uncomment the next line to force the base name to PhysXGpu_64,
  #   so the one remaining postfix yields PhysXGpu_64.dll
  # set_target_properties(PhysXGpu PROPERTIES OUTPUT_NAME "PhysXGpu_64")
endif()


# Record the two build‐output directories as CMake variables
set(PHYSX_SDK_SOURCE_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/sdk_source_bin"   CACHE INTERNAL "PhysX SDK core binary dir")
set(PHYSX_SDK_GPU_SOURCE_BIN_DIR   "${CMAKE_CURRENT_BINARY_DIR}/sdk_gpu_source_bin" CACHE INTERNAL "PhysX SDK GPU binary dir")

# Attach them as public (INTERFACE_) properties on the physx_lib target
set_target_properties(physx_lib PROPERTIES
  INTERFACE_PHYSX_SDK_SOURCE_BIN_DIR "${PHYSX_SDK_SOURCE_BIN_DIR}"
  INTERFACE_PHYSX_SDK_GPU_SOURCE_BIN_DIR "${PHYSX_SDK_GPU_SOURCE_BIN_DIR}"
)

if(PX_BUILDPVDRUNTIME)
  if(TARGET_BUILD_PLATFORM STREQUAL "windows" OR TARGET_BUILD_PLATFORM STREQUAL "linux")
    message(STATUS "Adding PVD Runtime...")
    add_subdirectory(${PHYSX_ROOT_DIR}/pvdruntime/compiler/cmake ${CMAKE_CURRENT_BINARY_DIR}/pvdruntime_bin)
  endif()
endif()
if(PX_BUILDSNIPPETS)
  message(STATUS "Adding Snippets...")
  add_subdirectory(${PHYSX_ROOT_DIR}/snippets/compiler/cmake ${CMAKE_CURRENT_BINARY_DIR}/sdk_snippets_bin)
endif()

# Link against PhysX libraries if available
set(PHYSX_LIBS "")
foreach(lib IN ITEMS PhysX PhysXCommon PhysXFoundation PhysXExtensions PhysXPvdSDK PhysXCooking PhysXCharacterKinematic PhysXVehicle)
  if(TARGET ${lib})
    message(STATUS "Linking physx_lib with ${lib}")
    target_link_libraries(physx_lib INTERFACE ${lib})
    list(APPEND PHYSX_LIBS ${lib})
  endif()
endforeach()

target_include_directories(physx_lib INTERFACE
  ${PHYSX_ROOT_DIR}/include
  ${PHYSX_ROOT_DIR}/source/foundation/include
  ${PHYSX_ROOT_DIR}/source/physx/include
  ${PHYSX_ROOT_DIR}/source/common/include
)

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

# GPU and CUDA integration
if(NOT CMAKE_CROSSCOMPILING AND (TARGET_BUILD_PLATFORM STREQUAL "windows" OR TARGET_BUILD_PLATFORM STREQUAL "linux"))
  if(TARGET PhysXGpu)
    message(STATUS "Linking physx_lib with PhysXGpu")
    target_link_libraries(physx_lib INTERFACE PhysXGpu)
  endif()
  if(CUDAToolkit_FOUND)
    message(STATUS "Linking physx_lib with CUDA::cudart")
    target_link_libraries(physx_lib INTERFACE CUDA::cudart)
    find_library(CUDA_CUDA_LIBRARY cuda HINTS ${CUDAToolkit_LIBRARY_DIR} PATH_SUFFIXES lib64 lib/x64)
    if(CUDA_CUDA_LIBRARY)
      message(STATUS "Found CUDA driver library: ${CUDA_CUDA_LIBRARY}")
      target_link_libraries(physx_lib INTERFACE ${CUDA_CUDA_LIBRARY})
    else()
      message(WARNING "CUDA driver library not found, GPU functionality may be limited")
    endif()
  endif()
endif()

message(STATUS "PhysX CMake configuration complete")

# Only execute installation commands when appropriate
if(PX_ENABLE_INSTALL)
  message(STATUS "PhysX installation enabled")

  # Install PhysX headers
  install(DIRECTORY ${PHYSX_ROOT_DIR}/include/
          DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
          FILES_MATCHING PATTERN "*.h*")

  # Install PhysX library targets
  install(TARGETS ${PHYSX_LIBS}
      EXPORT PhysXTargets
      ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
      LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
      INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

  # Export the targets for find_package
  install(EXPORT PhysXTargets
      FILE PhysXTargets.cmake
      NAMESPACE PhysX::
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PhysX)

  # Generate the version file for the configuration
  write_basic_package_version_file(
      "${CMAKE_CURRENT_BINARY_DIR}/PhysXConfigVersion.cmake"
      VERSION ${PROJECT_VERSION}
      COMPATIBILITY AnyNewerVersion)

  # Configure the config file
  configure_package_config_file(
      "${CMAKE_CURRENT_SOURCE_DIR}/source/compiler/cmake/PhysXConfig.cmake.in"
      "${CMAKE_CURRENT_BINARY_DIR}/PhysXConfig.cmake"
      INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PhysX)

  # Install the config files
  install(FILES
      "${CMAKE_CURRENT_BINARY_DIR}/PhysXConfig.cmake"
      "${CMAKE_CURRENT_BINARY_DIR}/PhysXConfigVersion.cmake"
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PhysX)
else()
  message(STATUS "PhysX installation disabled (not top-level project)")
  message(STATUS "However, shared library targets will still be available for linking.")

  # Install with proper RPATH settings so libraries can find each other
  set_target_properties(PhysXGpu PhysX PhysXCharacterKinematic PhysXCommon PhysXCooking PhysXExtensions PhysXFoundation
      PROPERTIES
      INSTALL_RPATH "$ORIGIN"
      BUILD_WITH_INSTALL_RPATH TRUE)

  install(TARGETS PhysXGpu PhysX PhysXCharacterKinematic PhysXCommon PhysXCooking PhysXExtensions PhysXFoundation
      LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
      RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()