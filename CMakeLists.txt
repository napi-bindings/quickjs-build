cmake_minimum_required(VERSION 3.16)

project(quickjs LANGUAGES C)

# static linking of libwinpthread-1.dll in mingw
if(WIN32)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static")
endif()

set(qjs_cflags -Wall -D_GNU_SOURCE)
if(CMAKE_C_COMPILER_ID MATCHES "AppleClang|Clang")
  list(
    APPEND
    qjs_cflags
    -Wextra
    -Wno-sign-compare
    -Wno-missing-field-initializers
    -Wno-unused-parameter
    -Wno-unused-variable
    -funsigned-char)
else()
  list(APPEND qjs_cflags -Wno-array-bounds -Wno-unused-variable
       -Wno-unused-but-set-variable)
endif()

file(STRINGS "VERSION" QJS_VERSION_STR)

message(
  STATUS
    "summary of build options:
    Target system:   ${CMAKE_SYSTEM_NAME}
    Compiler:
      C compiler:    ${CMAKE_C_COMPILER}
      CFLAGS:        ${qjs_cflags}
")

add_library(qjs STATIC src/cutils.c src/libbf.c src/libregexp.c
                       src/libunicode.c src/quickjs.c src/quickjs-libc.c)
set_target_properties(qjs PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
target_compile_options(qjs PRIVATE ${qjs_cflags})
target_compile_definitions(qjs PUBLIC QJS_VERSION_STR="${QJS_VERSION_STR}")
target_compile_definitions(qjs PUBLIC CONFIG_BIGNUM
                                      CONFIG_VERSION="${QJS_VERSION_STR}")
if(CMAKE_BUILD_TYPE MATCHES Debug)
  target_compile_definitions(qjs PRIVATE DUMP_LEAKS)
endif()

target_include_directories(qjs PUBLIC include)
target_include_directories(qjs PRIVATE src)
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  target_link_libraries(qjs atomic)
endif()

if(UNIX)
  target_link_libraries(qjs PRIVATE m dl pthread)
endif()

add_executable(qjsc src/qjsc.c)
target_link_libraries(qjsc PUBLIC qjs)

if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64")
  add_custom_command(
    OUTPUT repl.c qjscalc.c
    COMMAND
      qemu-aarch64 -L /usr/aarch64-linux-gnu/ qjsc -c -o
      ${CMAKE_CURRENT_BINARY_DIR}/repl.c -m
      ${CMAKE_CURRENT_SOURCE_DIR}/src/repl.js
    COMMAND
      qemu-aarch64 -L /usr/aarch64-linux-gnu/ qjsc -c -o
      ${CMAKE_CURRENT_BINARY_DIR}/qjscalc.c -m
      ${CMAKE_CURRENT_SOURCE_DIR}/src/qjscalc.js
    DEPENDS qjsc)
else()
  add_custom_command(
    OUTPUT repl.c qjscalc.c
    COMMAND qjsc -c -o ${CMAKE_CURRENT_BINARY_DIR}/repl.c -m
            ${CMAKE_CURRENT_SOURCE_DIR}/src/repl.js
    COMMAND qjsc -c -o ${CMAKE_CURRENT_BINARY_DIR}/qjscalc.c -m
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qjscalc.js
    DEPENDS qjsc)

endif()

add_executable(quickjs src/qjs.c ${CMAKE_CURRENT_BINARY_DIR}/qjscalc.c
                       ${CMAKE_CURRENT_BINARY_DIR}/repl.c)

target_link_libraries(quickjs PUBLIC qjs)

add_executable(run-test262 src/run-test262.c)
target_link_libraries(run-test262 PUBLIC qjs)
