#!/bin/sh
# Cross-compiles QuickJS with `zig cc` and packages the release archives.
#
#   scripts/build.sh [--test] [--list] <name>... | all
#
# Each <name> is one of the release artifacts listed by --list, e.g.
#
#   scripts/build.sh linux-arm64 windows-x86_64
#   scripts/build.sh --test linux-x86_64
#   scripts/build.sh all
#
# The build has two stages:
#   1. a native build of qjsc with the C compiler of this machine;
#   2. one cross-build per target with toolchains/zig.cmake, using the qjsc of
#      stage 1 to compile repl.js to bytecode.
# The WebAssembly targets contain the library only and skip stage 1.
#
# Requirements: cmake >= 3.20, a native C compiler, zig (see .zigversion).
# wasm32-emscripten is built with the Emscripten SDK (emcmake in PATH) instead
# of zig and is not part of "all".
#
# Environment:
#   ZIG            zig executable (default: zig)
#   BUILD_DIR      build tree (default: build)
#   DIST_DIR       where the archives are written (default: dist)
#   QJS_EMULATOR   CMake list used to run the binaries with --test when they
#                  are not native, e.g. "qemu-aarch64;-L;/usr/aarch64-linux-gnu"
#                  (wasm32-wasi defaults to node with smoke/run-wasi.mjs)
#   QJS_CTEST_ARGS extra arguments for ctest with --test, e.g. "-E test_std"
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_DIR=${BUILD_DIR:-$ROOT/build}
DIST_DIR=${DIST_DIR:-$ROOT/dist}

# <artifact name> <zig target>
TARGETS='
linux-x86_64       x86_64-linux-gnu.2.17
linux-arm64        aarch64-linux-gnu.2.17
linux-armv7        arm-linux-gnueabihf.2.17
linux-riscv64      riscv64-linux-gnu.2.27
linux-x86          x86-linux-gnu.2.17
linux-x86_64-musl  x86_64-linux-musl
linux-arm64-musl   aarch64-linux-musl
windows-x86_64     x86_64-windows-gnu
windows-arm64      aarch64-windows-gnu
windows-x86        x86-windows-gnu
macos-x86_64       x86_64-macos.11.0
macos-arm64        aarch64-macos.11.0
freebsd-x86_64     x86_64-freebsd
wasm32-wasi        wasm32-wasi
wasm32-emscripten  emscripten
'

usage() {
  awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"
}

zig_target_of() {
  echo "$TARGETS" | awk -v name="$1" '$1 == name { print $2 }'
}

run_tests=0
names=
for arg in "$@"; do
  case $arg in
    --test) run_tests=1 ;;
    --list)
      echo "$TARGETS" | awk 'NF { printf "%-18s %s\n", $1, $2 }'
      exit 0
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    all)
      all=$(echo "$TARGETS" | awk 'NF && $2 != "emscripten" { print $1 }' | tr '\n' ' ')
      names="$names $all"
      ;;
    -*)
      echo "unknown option: $arg" >&2
      exit 2
      ;;
    *) names="$names $arg" ;;
  esac
done

if [ -z "$names" ]; then
  usage >&2
  exit 2
fi

need_host=0
for name in $names; do
  if [ -z "$(zig_target_of "$name")" ]; then
    echo "unknown target: $name (see --list)" >&2
    exit 2
  fi
  case $name in
    wasm32-*) ;;
    *) need_host=1 ;;
  esac
done

if [ -n "${ZIG:-}" ]; then
  export ZIG
fi

mkdir -p "$BUILD_DIR" "$DIST_DIR"
BUILD_DIR=$(CDPATH= cd -- "$BUILD_DIR" && pwd)
DIST_DIR=$(CDPATH= cd -- "$DIST_DIR" && pwd)

# ---- stage 1: qjsc for this machine ------------------------------------------
host_qjsc=
if [ "$need_host" = 1 ]; then
  host_dir=$BUILD_DIR/host
  echo "==> host qjsc"
  cmake -S "$ROOT" -B "$host_dir" -DCMAKE_BUILD_TYPE=Release
  cmake --build "$host_dir" --target qjsc --parallel
  host_qjsc=$host_dir/qjsc
  [ -f "$host_qjsc" ] || host_qjsc=$host_dir/qjsc.exe
fi

# ---- stage 2: one build per target -------------------------------------------
for name in $names; do
  zig_target=$(zig_target_of "$name")
  dir=$BUILD_DIR/$name
  echo "==> $name ($zig_target)"

  emulator=${QJS_EMULATOR:-}
  set -- -S "$ROOT" -B "$dir" -DCMAKE_BUILD_TYPE=Release -DQJS_BUILD_SMOKE_TEST=ON
  case $name in
    wasm32-emscripten)
      # emcmake provides the toolchain file and node as the emulator
      ;;
    wasm32-wasi)
      set -- "$@" -DCMAKE_TOOLCHAIN_FILE="$ROOT/toolchains/zig.cmake" \
        -DZIG_TARGET="$zig_target"
      if [ -z "$emulator" ]; then
        if command -v node >/dev/null 2>&1; then
          emulator="node;--no-warnings;$ROOT/smoke/run-wasi.mjs"
        elif [ "$run_tests" = 1 ]; then
          echo "--test $name needs a WASI runtime: install Node.js or set" \
            "QJS_EMULATOR (e.g. \"wasmtime\")" >&2
          exit 1
        fi
      fi
      ;;
    *)
      set -- "$@" -DCMAKE_TOOLCHAIN_FILE="$ROOT/toolchains/zig.cmake" \
        -DZIG_TARGET="$zig_target" -DQJSC_EXECUTABLE="$host_qjsc"
      ;;
  esac
  if [ -n "$emulator" ]; then
    set -- "$@" "-DCMAKE_CROSSCOMPILING_EMULATOR=$emulator"
  fi

  if [ "$name" = wasm32-emscripten ]; then
    emcmake cmake "$@"
  else
    cmake "$@"
  fi
  cmake --build "$dir" --parallel

  if [ "$run_tests" = 1 ]; then
    # shellcheck disable=SC2086
    (cd "$dir" && ctest --output-on-failure ${QJS_CTEST_ARGS:-})
  fi

  # Archive layout: libqjs.a, the executables and include/ at the top level.
  stage=$dir/package
  rm -rf "$stage"
  mkdir -p "$stage"
  cp "$dir/libqjs.a" "$stage/"
  for tool in qjsc quickjs run-test262; do
    for file in "$dir/$tool" "$dir/$tool.exe"; do
      if [ -f "$file" ]; then cp "$file" "$stage/"; fi
    done
  done
  cp -R "$ROOT/include" "$stage/include"
  cp "$ROOT/VERSION" "$stage/VERSION"
  cp "$ROOT/LICENSE.quickjs" "$stage/LICENSE"

  archive=$DIST_DIR/qjs-$name.zip
  rm -f "$archive"
  (cd "$stage" && cmake -E tar cf "$archive" --format=zip -- *)
  echo "    $archive"
done
