# QuickJS JavaScript Engine

![QuickJS Build Matrix](https://github.com/napi-bindings/quickjs-build/workflows/QuickJS%20Build%20Matrix/badge.svg?branch=master)

## Version 2026-06-04

- [Introduction](#introduction)
- [Prebuilt archives](#prebuilt-archives)
- [Using the library](#using-the-library)
- [Using the WebAssembly builds](#using-the-webassembly-builds)
- [Building](#building)
- [Updating QuickJS](#updating-quickjs)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [References](#references)
- [Team](#team)
- [Acknowledgments](#acknowledgements)
- [License](#license)

## Introduction

**QuickJS** is a small and embeddable JavaScript engine. It supports most of the
**[ES2025](https://tc39.es/ecma262/)** specification including modules,
asynchronous generators, proxies and BigInt.

### Main Features:

- Small and easily embeddable: just a few **C** files, no external dependency,
**210 KiB** of x86 code for a simple hello world program.
- Fast interpreter with very low startup time: runs the tests of the
**[ECMAScript Test Suite](https://github.com/tc39/test262)** in less than 2
minutes on a single core of a desktop PC. The complete life cycle of a runtime
instance completes in less than 300 microseconds.
- Almost complete **ES2025** support.
- Passes nearly 100% of the
**[ECMAScript Test Suite](https://github.com/tc39/test262)** tests when selecting
the ES2025 features.
- Can compile JavaScript sources to executables with no external dependency.
- Garbage collection using reference counting (to reduce memory usage and have
deterministic behavior) with cycle removal.
- Command line interpreter with contextual colorization implemented in JavaScript.
- Small built-in standard library with **C** library wrappers.

This repository is a mirror of the original work that you can find
**[here](https://bellard.org/quickjs/)**. The files in `src/`, `include/` and
`tests/` are the unmodified files of the `quickjs-2026-06-04` release.

The mathematical extensions of the previous releases (BigFloat, BigDecimal,
operator overloading) were removed upstream and are no longer available. See the
[changelog](CHANGELOG.md) for the list of the API changes.

## Prebuilt archives

The main purpose of this repository is to build **QuickJS** as a static library
that you can include in your **C / C++** project. Every
[release](https://github.com/napi-bindings/quickjs-build/releases) provides the
following archives, together with a `SHA256SUMS` file:

| Archive | Platform | Notes |
| --- | --- | --- |
| `qjs-linux-x86_64.zip` | Linux x86_64 | glibc 2.17 or later |
| `qjs-linux-arm64.zip` | Linux AArch64 | glibc 2.17 or later |
| `qjs-linux-armv7.zip` | Linux ARMv7-A hard float | glibc 2.17 or later |
| `qjs-linux-riscv64.zip` | Linux RISC-V 64 (rv64gc) | glibc 2.27 or later |
| `qjs-linux-x86.zip` | Linux x86 32 bit | glibc 2.17 or later |
| `qjs-linux-x86_64-musl.zip` | Linux x86_64, musl | static executables, e.g. for Alpine |
| `qjs-linux-arm64-musl.zip` | Linux AArch64, musl | static executables, e.g. for Alpine |
| `qjs-windows-x86_64.zip` | Windows x86_64 | MinGW-w64 ABI, UCRT |
| `qjs-windows-arm64.zip` | Windows ARM64 | MinGW-w64 ABI, UCRT |
| `qjs-windows-x86.zip` | Windows x86 32 bit | MinGW-w64 ABI, UCRT |
| `qjs-windows-x86_64-mingw.zip` | Windows x86_64 | built with MinGW-w64 11 (GCC 13.2), msvcrt |
| `qjs-windows-x86-mingw.zip` | Windows x86 32 bit | built with MinGW-w64 11 (GCC 13.2), msvcrt |
| `qjs-macos-x86_64.zip` | macOS Intel | macOS 11 or later |
| `qjs-macos-arm64.zip` | macOS Apple Silicon | macOS 11 or later |
| `qjs-freebsd-x86_64.zip` | FreeBSD x86_64 | FreeBSD 14 or later |
| `qjs-wasm32-wasi.zip` | WebAssembly, WASI | engine only |
| `qjs-wasm32-emscripten.zip` | WebAssembly, Emscripten | engine only |

The native archives contain:

- `libqjs.a`: the static library (engine and `quickjs-libc`, the `std` and `os`
  modules);
- `qjsc`, `quickjs` and `run-test262`: the QuickJS compiler, the command line
  interpreter and the test262 runner;
- `include/`: `quickjs.h` and `quickjs-libc.h`;
- `VERSION` and `LICENSE`: the QuickJS version and its MIT license.

The WebAssembly archives contain `libqjs.a` with the engine only, `include/`,
`VERSION` and `LICENSE`.

The archives are cross-compiled from Linux with [`zig cc`](https://ziglang.org/)
at the version stored in [`.zigversion`](.zigversion), except
`qjs-wasm32-emscripten.zip` (Emscripten SDK) and the two `-mingw` archives, built
natively on Windows with the
[MinGW-Builds](https://github.com/niXman/mingw-builds-binaries) toolchain
`13.2.0-rt_v11-rev1`.

## Using the library

Compile and link your program against the content of the archive:

```
cc -Iinclude my_program.c libqjs.a -lm -lpthread -ldl -o my_program
```

`-ldl` is not needed on Windows, macOS and FreeBSD. On Windows add `-static` to
avoid the dependency on `libwinpthread-1.dll`.

[`smoke/embed.c`](smoke/embed.c) is a complete example that creates a runtime,
evaluates a script and reads the result back. The CI builds it for every target
and runs it wherever the binaries can be executed.

Notes for Windows:

- Two flavours of the Windows archives are provided. Pick the one that matches
  the toolchain you link with:

  | Your toolchain | Archive |
  | --- | --- |
  | MinGW-w64 12 or later with the UCRT: [MSYS2 UCRT64](https://www.msys2.org/docs/environments/), [llvm-mingw](https://github.com/mstorsjo/llvm-mingw), `zig cc` | `qjs-windows-x86_64.zip`, `qjs-windows-x86.zip`, `qjs-windows-arm64.zip` |
  | MinGW-w64 with the msvcrt runtime, including releases before 12: MSYS2 MINGW64, MinGW-Builds, Debian and Ubuntu `gcc-mingw-w64` | `qjs-windows-x86_64-mingw.zip`, `qjs-windows-x86-mingw.zip` |

- MinGW-w64 12 moved winpthreads to 64-bit `time_t` symbols: code compiled with
  its headers references `clock_gettime64` and `pthread_cond_timedwait64`, which
  older releases do not have. Linking the zig archives with an older MinGW-w64
  fails with undefined references to these two functions. The `-mingw` archives
  are compiled with MinGW-w64 11 and reference the classic names instead.
- Do not mix C runtimes: link the UCRT archives into UCRT programs and the
  `-mingw` (msvcrt) archives into msvcrt programs.
- Microsoft Visual C++ is not supported by QuickJS.

You can also add this repository to a **CMake** project and let it build the
library with your own toolchain:

```cmake
add_subdirectory(quickjs-build)
target_link_libraries(my_program PRIVATE qjs)
```

## Using the WebAssembly builds

Both WebAssembly archives contain the engine only: `quickjs-libc` needs
processes, pipes and signals that are not available there. Your program provides
what it needs (for example a `print` function) through the QuickJS C API.

### WASI

Link `libqjs.a` with a WASI toolchain such as `zig cc -target wasm32-wasi` or
[wasi-sdk](https://github.com/WebAssembly/wasi-sdk):

```
zig cc -target wasm32-wasi -O2 -Iinclude my_program.c libqjs.a \
  -Wl,-z,stack-size=1048576 -o my_program.wasm
```

The resulting module runs on any WASI runtime, for example
[Wasmtime](https://wasmtime.dev/) or Node.js (see
[`smoke/run-wasi.mjs`](smoke/run-wasi.mjs)).

**Set the stack limit of the runtime.** The WebAssembly call stack belongs to the
host and is invisible to the engine, which only measures the stack kept in the
linear memory. With the default limit of QuickJS (1 MiB) a runaway recursion
exhausts the call stack of the host first and the module traps instead of
throwing a JavaScript `InternalError`. Lower the limit right after creating the
runtime and give the module a linear memory stack larger than that limit:

```c
JSRuntime *rt = JS_NewRuntime();
JS_SetMaxStackSize(rt, 256 * 1024);
```

With these values the recursion test of `smoke/embed.c` ends with a catchable
exception on Node.js 22. Other hosts may need a different value.

### Emscripten

Link `libqjs.a` with `emcc`:

```
emcc -O2 -Iinclude my_program.c libqjs.a -o my_program.js
```

When built with Emscripten the engine disables `Atomics` and its own stack
check, so a runaway recursion ends with the `RangeError` of the host.

## Building

If you want to build the QuickJS library on your own the first step is to clone
this repository:

`> git clone https://github.com/napi-bindings/quickjs-build.git`

You need **CMake** 3.20 or later and **GCC** or **Clang**.

### Native build

```
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --build build --target check
```

The last command runs the QuickJS tests stored in `tests/`.

On **Windows** install a MinGW-w64 toolchain (for example with
[MSYS2](https://www.msys2.org/)), be sure that `gcc` is in your path of execution
and add `-G "MinGW Makefiles"` to the first command.

On **Linux** install the dependencies with:

```
sudo apt-get update
sudo apt-get install build-essential cmake -y
```

On **macOS** install the `Xcode Command Line Tools` running
`xcode-select --install` and CMake running `brew install cmake`.

`-DCMAKE_BUILD_TYPE` could be set with one of the following two values:

- Release
- Debug

### Build options

| Option | Default | Description |
| --- | --- | --- |
| `QJS_BUILD_LIBC` | `ON`, `OFF` for WebAssembly | Include `quickjs-libc` (the `std` and `os` modules) in `libqjs.a` |
| `QJS_BUILD_TOOLS` | `ON`, `OFF` for WebAssembly | Build `qjsc`, `quickjs` and `run-test262` |
| `QJS_BUILD_SMOKE_TEST` | `OFF` | Build `smoke/embed.c` and add it to the tests |
| `QJSC_EXECUTABLE` | empty | `qjsc` built for the host, required to build the tools when cross-compiling |

### Cross-compiling with zig

[`toolchains/zig.cmake`](toolchains/zig.cmake) is a CMake toolchain file that
uses `zig cc` as the C compiler. With it one machine builds the library for all
the platforms of the table above, with no other cross-compiler or SDK. The CI
uses zig 0.17.1; the build also works with zig 0.16.0.

The script [`scripts/build.sh`](scripts/build.sh) runs the whole process and
writes the archives to `dist/`. It needs a POSIX shell (Linux, macOS, WSL):

```
sh scripts/build.sh --list
sh scripts/build.sh linux-arm64 windows-x86_64
sh scripts/build.sh --test linux-x86_64
sh scripts/build.sh all
```

The build has two stages, because the `quickjs` executable embeds the bytecode of
`repl.js` generated by `qjsc`, and a cross-compiled `qjsc` cannot run on the
build machine:

```
# 1. qjsc for the build machine
cmake -S . -B build/host -DCMAKE_BUILD_TYPE=Release
cmake --build build/host --target qjsc

# 2. the target
cmake -S . -B build/linux-arm64 -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE=toolchains/zig.cmake \
  -DZIG_TARGET=aarch64-linux-gnu.2.17 \
  -DQJSC_EXECUTABLE=$PWD/build/host/qjsc
cmake --build build/linux-arm64
```

`ZIG_TARGET` is a zig target triple; the suffix after the ABI selects the minimum
glibc version and the suffix after `macos` the minimum macOS version. Set
`CMAKE_CROSSCOMPILING_EMULATOR` to run the tests of a foreign architecture, for
example `-DCMAKE_CROSSCOMPILING_EMULATOR="qemu-aarch64;-L;/usr/aarch64-linux-gnu"`.

The WebAssembly targets have no tools and skip the first stage:

```
sh scripts/build.sh --test wasm32-wasi
sh scripts/build.sh --test wasm32-emscripten
```

The second command needs the [Emscripten SDK](https://emscripten.org/) with
`emcmake` in your path of execution, instead of zig.

## Updating QuickJS

The QuickJS files are copied without changes from the upstream tarball:

- `src/`: the `.c`, `.h` and `repl.js` files needed by the library and the tools;
- `include/`: `quickjs.h` and `quickjs-libc.h`;
- `tests/`: the test scripts run by the `check` target;
- `VERSION` and `LICENSE.quickjs` (the upstream `LICENSE`).

To update, replace these files with the ones of the new release, review the
source list in `CMakeLists.txt` against the upstream `Makefile` and run the
tests.

## References

- **QuickJS** documentation [HTML version](https://bellard.org/quickjs/quickjs.html), [PDF version](https://bellard.org/quickjs/quickjs.pdf).
- **QuickJS** [source repository](https://github.com/bellard/quickjs).
- [Writing native modules in C for QuickJS](https://medium.com/@calbertts/writing-native-modules-in-c-for-quickjs-engine-49043587f2e2).
- [How to create asynchronous code for QuickJS](https://medium.com/@calbertts/how-to-create-asynchronous-apis-for-quickjs-8aca5488bb2e).

## Team

### Nicola Del Gobbo

<https://github.com/NickNaso/>

<https://www.npmjs.com/~nicknaso>

<https://twitter.com/NickNaso>

## Acknowledgements

Thank you to all people that encourage me every day.

## License

Licensed under [Apache license V2](./LICENSE).

QuickJS is licensed under the [MIT license](./LICENSE.quickjs).
