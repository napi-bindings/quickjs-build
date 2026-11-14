# CMake toolchain file that cross-compiles with `zig cc`.
#
#   cmake -S . -B build/aarch64-linux \
#     -DCMAKE_TOOLCHAIN_FILE=toolchains/zig.cmake \
#     -DZIG_TARGET=aarch64-linux-gnu.2.17 \
#     -DQJSC_EXECUTABLE=/path/to/host/qjsc
#
# ZIG_TARGET is a zig target triple: <arch>-<os>[.<version>][-<abi>[.<version>]]
#   x86_64-linux-gnu.2.17   Linux, glibc 2.17 or later
#   aarch64-linux-musl      Linux, static musl
#   x86_64-windows-gnu      Windows (MinGW-w64, UCRT)
#   aarch64-macos.11.0      macOS 11 or later
#   wasm32-wasi             WebAssembly System Interface
# `zig targets` prints the full list.
#
# ZIG (variable or environment variable) is the zig executable. Default: the
# `zig` found in PATH.

if(NOT DEFINED ZIG_TARGET AND DEFINED ENV{ZIG_TARGET})
  set(ZIG_TARGET "$ENV{ZIG_TARGET}")
endif()
if(NOT ZIG_TARGET)
  message(
    FATAL_ERROR "ZIG_TARGET is required, e.g. -DZIG_TARGET=x86_64-linux-gnu.2.17"
  )
endif()

if(NOT DEFINED ZIG AND DEFINED ENV{ZIG})
  set(ZIG "$ENV{ZIG}")
endif()
if(NOT ZIG)
  set(ZIG "zig")
endif()

# The toolchain file is read again by every try_compile() project: forward the
# settings to them.
set(ENV{ZIG_TARGET} "${ZIG_TARGET}")
set(ENV{ZIG} "${ZIG}")
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES ZIG ZIG_TARGET)

if(NOT ZIG_TARGET MATCHES "^([a-z0-9_]+)-([a-z]+)")
  message(FATAL_ERROR "Cannot parse ZIG_TARGET '${ZIG_TARGET}'")
endif()
set(_zig_arch "${CMAKE_MATCH_1}")
set(_zig_os "${CMAKE_MATCH_2}")

if(_zig_os STREQUAL "linux")
  set(CMAKE_SYSTEM_NAME Linux)
elseif(_zig_os STREQUAL "windows")
  set(CMAKE_SYSTEM_NAME Windows)
elseif(_zig_os STREQUAL "macos")
  set(CMAKE_SYSTEM_NAME Darwin)
elseif(_zig_os STREQUAL "freebsd")
  set(CMAKE_SYSTEM_NAME FreeBSD)
elseif(_zig_os STREQUAL "wasi")
  set(CMAKE_SYSTEM_NAME WASI)
else()
  set(CMAKE_SYSTEM_NAME Generic)
endif()
set(CMAKE_SYSTEM_PROCESSOR "${_zig_arch}")

# `zig cc`, `zig ar` and `zig ranlib` are sub-commands of one executable. CMake
# accepts a compiler with mandatory arguments as a list; the archiver is set
# through the rule variables so that no wrapper script is needed.
set(CMAKE_C_COMPILER "${ZIG}" cc)
set(CMAKE_C_COMPILER_TARGET "${ZIG_TARGET}")

set(CMAKE_C_ARCHIVE_CREATE "\"${ZIG}\" ar qc <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_APPEND "\"${ZIG}\" ar q <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_FINISH "\"${ZIG}\" ranlib <TARGET>")

# Headers and libraries come from zig, never from the build machine.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# `zig cc` emits debug information unless told otherwise. Keep the optimized
# configurations free of it, as they are with GCC and Clang.
set(CMAKE_C_FLAGS_RELEASE_INIT "-g0")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT "-g0")
