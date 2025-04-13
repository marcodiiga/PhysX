cmake_minimum_required(VERSION 3.16)
project(PhysX LANGUAGES C CXX)

# Base configuration
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Dependency management
include(FetchContent)

# RapidJSON (header-only)
FetchContent_Declare(
    rapidjson
    GIT_REPOSITORY https://github.com/Tencent/rapidjson
    GIT_TAG 1a803826f1197b5e30703afe8b38ed31c7a28f76 # v1.1.0 closest match
)
FetchContent_MakeAvailable(rapidjson)

# Platform-specific dependencies
if(WIN32)
    # vswhere (build from source)
    FetchContent_Declare(
        vswhere
        GIT_REPOSITORY https://github.com/microsoft/vswhere
        GIT_TAG 2.8.4
    )
    FetchContent_MakeAvailable(vswhere)

    # FreeGLUT
    FetchContent_Declare(
        freeglut
        GIT_REPOSITORY https://github.com/FreeGLUTProject/freeglut
        GIT_TAG FG_3_4_0
    )
    FetchContent_MakeAvailable(freeglut)
elseif(UNIX AND NOT APPLE)
    find_package(OpenGL REQUIRED)
endif()

# PhysX build configuration
option(PX_BUILDSNIPPETS "Build PhysX snippets" OFF)
option(PX_BUILDPVDRUNTIME "Build OmniPVD runtime" OFF)
option(PX_GENERATE_GPU_PROJECTS "Enable GPU projects" OFF)
option(PX_GENERATE_GPU_PROJECTS_ONLY "Enable GPU projects only" OFF)

# CUDA configuration
if(PX_GENERATE_GPU_PROJECTS OR PX_GENERATE_GPU_PROJECTS_ONLY)
    enable_language(CUDA)
    find_package(CUDAToolkit REQUIRED)

    if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
        set(CMAKE_CUDA_ARCHITECTURES 75)
    endif()
endif()

# Core PhysX build
add_subdirectory(source/compiler/cmake)

# Optional components
if(PX_GENERATE_GPU_PROJECTS OR PX_GENERATE_GPU_PROJECTS_ONLY)
    add_subdirectory(source/compiler/cmakegpu)
endif()

if(PX_BUILDSNIPPETS)
    add_subdirectory(snippets/compiler/cmake)
endif()

if(PX_BUILDPVDRUNTIME)
    add_subdirectory(pvdruntime/compiler/cmake)
endif()

# Installation setup
include(GNUInstallDirs)
install(
    DIRECTORY ${rapidjson_SOURCE_DIR}/include/rapidjson
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

if(WIN32)
    install(
        FILES ${vswhere_BINARY_DIR}/vswhere.exe
        DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()
