/*
 * Empty <setjmp.h> used only for the wasm32-wasi build of QuickJS.
 *
 * src/dtoa.c includes <setjmp.h> without using setjmp() or longjmp(). The
 * wasi-libc header stops the compilation unless WebAssembly exception handling
 * is enabled, so this directory is put first in the include path for that one
 * target (see CMakeLists.txt). The QuickJS sources stay unmodified.
 */
#ifndef QJS_COMPAT_WASI_SETJMP_H
#define QJS_COMPAT_WASI_SETJMP_H
#endif
