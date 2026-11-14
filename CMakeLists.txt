cmake_minimum_required(VERSION 3.20)

project(quickjs LANGUAGES C)

file(STRINGS "VERSION" QJS_VERSION_STR)

# ------------------------------------------------------------------------------
# Target platform
# ------------------------------------------------------------------------------
set(QJS_IS_WASI OFF)
if(CMAKE_SYSTEM_NAME STREQUAL "WASI")
  set(QJS_IS_WASI ON)
endif()

set(QJS_IS_WASM OFF)
if(QJS_IS_WASI OR EMSCRIPTEN)
  set(QJS_IS_WASM ON)
endif()

# ------------------------------------------------------------------------------
# Options
# ------------------------------------------------------------------------------
# quickjs-libc (the `std` and `os` modules) needs processes, pipes and signals.
# WebAssembly targets get the engine only.
set(_qjs_native ON)
if(QJS_IS_WASM)
  set(_qjs_native OFF)
endif()

option(QJS_BUILD_LIBC "Include quickjs-libc (std and os modules) in the library"
       ${_qjs_native})
option(QJS_BUILD_TOOLS "Build the qjsc, quickjs and run-test262 executables"
       ${_qjs_native})
option(QJS_BUILD_SMOKE_TEST "Build the embedding smoke test (smoke/embed.c)" OFF)
set(QJSC_EXECUTABLE
    ""
    CACHE FILEPATH
          "qjsc built for the host. Required to build the tools when cross-compiling"
)

if(QJS_BUILD_TOOLS AND NOT QJS_BUILD_LIBC)
  message(FATAL_ERROR "QJS_BUILD_TOOLS requires QJS_BUILD_LIBC")
endif()

# ------------------------------------------------------------------------------
# Compiler flags
# ------------------------------------------------------------------------------
# -fwrapv: QuickJS relies on signed overflow wrapping (same as upstream Makefile)
set(qjs_cflags -Wall -fwrapv)
if(CMAKE_C_COMPILER_ID MATCHES "Clang")
  list(
    APPEND
    qjs_cflags
    -Wextra
    -Wno-sign-compare
    -Wno-missing-field-initializers
    -Wno-unused-parameter
    -Wno-unused-variable
    -Wno-unused-but-set-variable
    -funsigned-char)
else()
  list(APPEND qjs_cflags -Wno-array-bounds -Wno-format-truncation
       -Wno-unused-variable -Wno-unused-but-set-variable)
endif()

set(qjs_defines _GNU_SOURCE)
if(WIN32)
  # standard snprintf behavior with MinGW
  list(APPEND qjs_defines __USE_MINGW_ANSI_STDIO)
endif()

message(
  STATUS
    "summary of build options:
    QuickJS version: ${QJS_VERSION_STR}
    Target system:   ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}
    Cross-compiling: ${CMAKE_CROSSCOMPILING}
    quickjs-libc:    ${QJS_BUILD_LIBC}
    Tools:           ${QJS_BUILD_TOOLS}
    Compiler:
      C compiler:    ${CMAKE_C_COMPILER}
      CFLAGS:        ${qjs_cflags}
")

# ------------------------------------------------------------------------------
# Static library
# ------------------------------------------------------------------------------
set(qjs_sources src/cutils.c src/dtoa.c src/libregexp.c src/libunicode.c
                src/quickjs.c)
if(QJS_BUILD_LIBC)
  list(APPEND qjs_sources src/quickjs-libc.c)
endif()

add_library(qjs STATIC ${qjs_sources})
set_target_properties(qjs PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
if(NOT QJS_IS_WASM)
  # lets the static library be linked into shared objects (e.g. Node.js addons)
  set_target_properties(qjs PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()
target_compile_options(qjs PRIVATE ${qjs_cflags})
target_compile_definitions(qjs PRIVATE ${qjs_defines})
target_compile_definitions(qjs PUBLIC QJS_VERSION_STR="${QJS_VERSION_STR}"
                                      CONFIG_VERSION="${QJS_VERSION_STR}")
if(CMAKE_BUILD_TYPE MATCHES Debug)
  target_compile_definitions(qjs PRIVATE DUMP_LEAKS=1)
endif()

target_include_directories(qjs PUBLIC include)
target_include_directories(qjs PRIVATE src)

if(QJS_IS_WASI)
  # The sources are compiled unmodified. Two build-side adjustments are needed:
  # - dtoa.c includes <setjmp.h> without using it, and the wasi-libc header
  #   refuses to compile without exception handling: compat/wasi provides an
  #   empty replacement.
  # - quickjs.c calls malloc_usable_size() but includes <malloc.h> on Linux only.
  target_include_directories(qjs BEFORE PRIVATE compat/wasi)
  target_compile_options(qjs PRIVATE -include malloc.h)
endif()

if(WIN32)
  target_link_libraries(qjs PUBLIC m pthread)
elseif(UNIX AND NOT QJS_IS_WASM)
  find_package(Threads REQUIRED)
  target_link_libraries(qjs PUBLIC m Threads::Threads ${CMAKE_DL_LIBS})
endif()

# ------------------------------------------------------------------------------
# Executables
# ------------------------------------------------------------------------------
if(QJS_BUILD_TOOLS)
  add_executable(qjsc src/qjsc.c)
  target_compile_options(qjsc PRIVATE ${qjs_cflags})
  target_compile_definitions(
    qjsc PRIVATE ${qjs_defines} CONFIG_CC="cc"
                 CONFIG_PREFIX="${CMAKE_INSTALL_PREFIX}")
  target_link_libraries(qjsc PRIVATE qjs)

  # repl.js is compiled to bytecode by qjsc. When cross-compiling, the qjsc just
  # built cannot run on the host: a host qjsc must be provided.
  if(QJSC_EXECUTABLE)
    set(_qjsc_command "${QJSC_EXECUTABLE}")
    set(_qjsc_depends "")
  elseif(CMAKE_CROSSCOMPILING)
    message(
      FATAL_ERROR
        "Cross-compiling the tools needs a qjsc that runs on this machine.\n"
        "Build one first with a native build (cmake --build <dir> --target qjsc)"
        " and pass -DQJSC_EXECUTABLE=<path>, or use scripts/build.sh.")
  else()
    set(_qjsc_command qjsc)
    set(_qjsc_depends qjsc)
  endif()

  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/repl.c
    COMMAND ${_qjsc_command} -s -c -o ${CMAKE_CURRENT_BINARY_DIR}/repl.c -m
            repl.js
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src
    DEPENDS ${_qjsc_depends} ${CMAKE_CURRENT_SOURCE_DIR}/src/repl.js
    COMMENT "Compiling repl.js to bytecode"
    VERBATIM)

  add_executable(quickjs src/qjs.c ${CMAKE_CURRENT_BINARY_DIR}/repl.c)
  target_compile_options(quickjs PRIVATE ${qjs_cflags})
  target_compile_definitions(quickjs PRIVATE ${qjs_defines})
  target_link_libraries(quickjs PRIVATE qjs)

  add_executable(run-test262 src/run-test262.c)
  target_compile_options(run-test262 PRIVATE ${qjs_cflags})
  target_compile_definitions(run-test262 PRIVATE ${qjs_defines})
  target_link_libraries(run-test262 PRIVATE qjs)

  if(WIN32)
    # static linking of libwinpthread-1.dll in mingw
    foreach(_tool qjsc quickjs run-test262)
      target_link_options(${_tool} PRIVATE -static)
    endforeach()
  elseif(NOT APPLE)
    # export the engine symbols to native modules loaded with dlopen()
    foreach(_tool qjsc quickjs run-test262)
      set_target_properties(${_tool} PROPERTIES ENABLE_EXPORTS ON)
    endforeach()
  endif()
endif()

# ------------------------------------------------------------------------------
# Embedding smoke test: a small C program that uses the engine API only
# ------------------------------------------------------------------------------
if(QJS_BUILD_SMOKE_TEST)
  add_executable(qjs-smoke smoke/embed.c)
  target_link_libraries(qjs-smoke PRIVATE qjs)
  if(QJS_IS_WASI)
    set_target_properties(qjs-smoke PROPERTIES SUFFIX ".wasm")
    # 1 MiB of linear memory stack, well above the limit set in embed.c
    target_link_options(qjs-smoke PRIVATE -Wl,-z,stack-size=1048576)
  endif()
endif()

# ------------------------------------------------------------------------------
# Tests: `ctest` or the `check` target.
# When cross-compiling, set CMAKE_CROSSCOMPILING_EMULATOR to run them
# (e.g. "qemu-aarch64;-L;/usr/aarch64-linux-gnu").
# ------------------------------------------------------------------------------
enable_testing()

if(QJS_BUILD_TOOLS)
  set(qjs_test_scripts test_closure test_language test_loop test_bigint
                       test_cyclic_import test_worker)
  if(NOT WIN32)
    list(APPEND qjs_test_scripts test_std test_rw_handler)
  endif()

  foreach(_test ${qjs_test_scripts})
    add_test(
      NAME ${_test}
      COMMAND quickjs tests/${_test}.js
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  endforeach()
  add_test(
    NAME test_builtin
    COMMAND quickjs --std tests/test_builtin.js
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()

if(QJS_BUILD_SMOKE_TEST)
  add_test(NAME smoke_embed COMMAND qjs-smoke)
endif()

add_custom_target(
  check
  COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  USES_TERMINAL)
if(QJS_BUILD_TOOLS)
  add_dependencies(check quickjs)
endif()
if(QJS_BUILD_SMOKE_TEST)
  add_dependencies(check qjs-smoke)
endif()
