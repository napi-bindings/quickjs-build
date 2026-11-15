/*
 * Embedding smoke test for the QuickJS static library.
 *
 * It uses the engine API only (quickjs.h, no quickjs-libc), so the same file
 * checks every build of the library: native, wasm32-wasi and Emscripten.
 * It evaluates scripts that touch features added since the 2022 snapshot and
 * compares each result with the expected string.
 *
 * Exit status: 0 on success, 1 on failure.
 */
#include <stdio.h>
#include <string.h>

#include "quickjs.h"

/* defined by CMakeLists.txt; absent when this file is compiled by hand against
   a release archive */
#ifndef QJS_VERSION_STR
#define QJS_VERSION_STR "static library"
#endif

static const char features_script[] =
    "const set = new Set([1, 2, 3]).union(new Set([3, 4]));\n"
    "const it = Iterator.from([1, 2, 3, 4]).map((x) => x * 2).toArray();\n"
    "const re = /(?<y>\\d{4})-(?<m>\\d\\d)/.exec('2026-06').groups;\n"
    "JSON.stringify({\n"
    "  big: (2n ** 100n).toString(),\n"
    "  set: [...set],\n"
    "  it,\n"
    "  re,\n"
    "  sum: Math.sumPrecise([0.1, 0.2, 0.3]),\n"
    "  b64: new Uint8Array([1, 2, 3]).toBase64(),\n"
    "  f: (0.1 + 0.2).toFixed(20),\n"
    "  f16: typeof Float16Array,\n"
    "  weakref: typeof WeakRef,\n"
    "});\n";

static const char features_expected[] =
    "{\"big\":\"1267650600228229401496703205376\","
    "\"set\":[1,2,3,4],"
    "\"it\":[2,4,6,8],"
    "\"re\":{\"y\":\"2026\",\"m\":\"06\"},"
    "\"sum\":0.6,"
    "\"b64\":\"AQID\","
    "\"f\":\"0.30000000000000004441\","
    "\"f16\":\"function\","
    "\"weakref\":\"function\"}";

#ifndef __EMSCRIPTEN__
/* Runaway recursion must end with a catchable InternalError. The engine has no
   stack check when built with Emscripten, so this part is skipped there. */
static const char overflow_script[] =
    "let depth = 0;\n"
    "function recurse() { depth++; recurse(); }\n"
    "let error = 'none';\n"
    "try { recurse(); } catch (e) { error = e.constructor.name; }\n"
    "error + ' ' + (depth > 100);\n";

static const char overflow_expected[] = "InternalError true";
#endif

static int check(JSContext *ctx, const char *name, const char *script,
                 const char *expected)
{
    JSValue val;
    const char *str;
    int ret = 1;

    val = JS_Eval(ctx, script, strlen(script), name, JS_EVAL_TYPE_GLOBAL);
    if (JS_IsException(val)) {
        JSValue exc = JS_GetException(ctx);
        str = JS_ToCString(ctx, exc);
        fprintf(stderr, "%s: exception: %s\n", name, str ? str : "?");
        JS_FreeCString(ctx, str);
        JS_FreeValue(ctx, exc);
    } else {
        str = JS_ToCString(ctx, val);
        if (str && strcmp(str, expected) == 0) {
            ret = 0;
        } else {
            fprintf(stderr, "%s: unexpected result\n  got:      %s\n  expected: %s\n",
                    name, str ? str : "?", expected);
        }
        JS_FreeCString(ctx, str);
    }
    JS_FreeValue(ctx, val);
    return ret;
}

int main(void)
{
    JSRuntime *rt;
    JSContext *ctx;
    int ret;

    rt = JS_NewRuntime();
    if (!rt) {
        fprintf(stderr, "JS_NewRuntime failed\n");
        return 1;
    }
#ifdef __wasi__
    /* The WebAssembly call stack belongs to the host and is not visible to the
       engine: keep the QuickJS limit (measured on the linear memory stack)
       low enough to be reached first. See "Using the WebAssembly builds" in
       README.md. */
    JS_SetMaxStackSize(rt, 256 * 1024);
#endif
    ctx = JS_NewContext(rt);
    if (!ctx) {
        fprintf(stderr, "JS_NewContext failed\n");
        JS_FreeRuntime(rt);
        return 1;
    }

    ret = check(ctx, "<features>", features_script, features_expected);
#ifndef __EMSCRIPTEN__
    ret |= check(ctx, "<overflow>", overflow_script, overflow_expected);
#endif

    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);

    if (ret == 0)
        printf("QuickJS %s: embedding smoke test passed\n", QJS_VERSION_STR);
    return ret;
}
