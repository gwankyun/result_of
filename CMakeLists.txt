# cmake最低版本
cmake_minimum_required(VERSION 3.23)

# 項目名
project(result_of)

# 啟用IDE目錄功能
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# 包括模板
set(CMAKE_MODULE_PATH
  ${CMAKE_MODULE_PATH}
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake
)
include(CMakePrintHelpers)
include(common)
include(GNUInstallDirs)

# 輸出目錄
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_SOURCE_DIR}/bin)

add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/W4;/MP;/Zc:__cplusplus;>")

set(target result_of)

add_library(${target} INTERFACE)

install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/lite"
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

target_include_directories(${target}
  INTERFACE
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include;${CMAKE_CURRENT_SOURCE_DIR}/include/lite/result_of>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR};${CMAKE_INSTALL_INCLUDEDIR}/lite/result_of>" 
)

target_create_package(
  TARGET ${target}
  VERSION "0.0.1"
  NAMESPACE lite
)

# 生成執行文件
set(test result_of_test)
add_executable(${test})

target_sources(${test}
  PRIVATE
    src/main.cpp
)
