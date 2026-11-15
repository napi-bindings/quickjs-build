# Archive rules for the zig toolchain, loaded by toolchains/zig.cmake through
# CMAKE_USER_MAKE_RULES_OVERRIDE_C.
#
# They cannot be set in the toolchain file itself: CMake reads the platform
# files after it, and some of them (Platform/Windows-GNU.cmake among others)
# set CMAKE_C_ARCHIVE_CREATE unconditionally to use CMAKE_AR. CMAKE_AR is then
# the `ar` of the build machine, which writes no usable symbol index for objects
# of a foreign architecture (e.g. ARM64 COFF): the library is created, but every
# link against it fails with undefined symbols. This file is read after the
# platform files, so `zig ar` is used for every target.

set(CMAKE_C_ARCHIVE_CREATE "\"${ZIG}\" ar qc <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_APPEND "\"${ZIG}\" ar q <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_FINISH "\"${ZIG}\" ranlib <TARGET>")
set(CMAKE_C_ARCHIVE_CREATE_IPO "${CMAKE_C_ARCHIVE_CREATE}")
set(CMAKE_C_ARCHIVE_APPEND_IPO "${CMAKE_C_ARCHIVE_APPEND}")
set(CMAKE_C_ARCHIVE_FINISH_IPO "${CMAKE_C_ARCHIVE_FINISH}")
