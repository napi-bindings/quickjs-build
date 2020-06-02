# quickjs-build
---

QuickJS Javascript Engine
News
2020-04-12:
New release
2020-03-16:
New release
2020-01-19:
New release with experimental BigDecimal support and updated operator overloading.
Small Javascript programs to compute one billion digits of pi.
Introduction
QuickJS is a small and embeddable Javascript engine. It supports the ES2020 specification including modules, asynchronous generators, proxies and BigInt.
It optionally supports mathematical extensions such as big decimal floating point numbers (BigDecimal), big binary floating point numbers (BigFloat) and operator overloading.

Main Features:

Small and easily embeddable: just a few C files, no external dependency, 210 KiB of x86 code for a simple hello world program.
Fast interpreter with very low startup time: runs the 69000 tests of the ECMAScript Test Suite in about 95 seconds on a single core of a desktop PC. The complete life cycle of a runtime instance completes in less than 300 microseconds.
Almost complete ES2020 support including modules, asynchronous generators and full Annex B support (legacy web compatibility).
Passes nearly 100% of the ECMAScript Test Suite tests when selecting the ES2020 features.
Can compile Javascript sources to executables with no external dependency.
Garbage collection using reference counting (to reduce memory usage and have deterministic behavior) with cycle removal.
Mathematical extensions: BigDecimal, BigFloat, operator overloading, bigint mode, math mode.
Command line interpreter with contextual colorization implemented in Javascript.
Small built-in standard library with C library wrappers.
Benchmark
Online Demo
An online demonstration of the QuickJS engine with its mathematical extensions is available at numcalc.com. It was compiled from C to WASM/asm.js with Emscripten.
qjs and qjscalc can be run in JSLinux.

Documentation
QuickJS documentation: HTML version, PDF version.
Specification of the JS Bignum Extensions: HTML version, PDF version.

Download
QuickJS source code: quickjs-2020-04-12.tar.xz
QuickJS extras (contain the unicode files needed to rebuild the unicode tables and the bench-v8 benchmark): quickjs-extras-2020-04-12.tar.xz
Unofficial git mirror.
Binary releases for Linux are available in jsvu and here.
Typescript compiler compiled with QuickJS: quickjs-typescript-linux-x86.tar.xz
Babel compiler compiled with QuickJS: quickjs-babel-linux-x86.tar.xz
Sub-projects
QuickJS embeds the following C libraries which can be used in other projects:
libregexp: small and fast regexp library fully compliant with the Javascript ES 2019 specification.
libunicode: small unicode library supporting case conversion, unicode normalization, unicode script queries, unicode general category queries and all unicode binary properties.
libbf: small library implementing arbitrary precision IEEE 754 floating point operations and transcendental functions with exact rounding. It is maintained as a separate project.
Links
QuickJS Development mailing list
Licensing
QuickJS is released under the MIT license.
Unless otherwise specified, the QuickJS sources are copyright Fabrice Bellard and Charlie Gordon.
