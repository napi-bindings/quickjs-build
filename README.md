# QuickJS JavaScript Engine

![QuickJS Build Matrix](https://github.com/napi-bindings/quickjs-build/workflows/QuickJS%20Build%20Matrix/badge.svg?branch=master)

## Version 2020-04-12

- [Introduction](#introduction)
- [Building](#building)
- [Code of conduct](CODE_OF_CONDUCT)
- [Team](#team)
- [References](#references)
- [Acknowledgments](#acknowledgements)
- [License](#license)

## Introduction

QuickJS is a small and embeddable Javascript engine. It supports the **[ES2020](https://tc39.github.io/ecma262/)**
 specification including modules, asynchronous generators, proxies and BigInt.

It optionally supports mathematical extensions such as big decimal floating point
numbers (BigDecimal), big binary floating point numbers (BigFloat) and operator 
overloading.

### Main Features:

- Small and easily embeddable: just a few **C** files, no external dependency, 
**210 KiB** of x86 code for a simple hello world program.
- Fast interpreter with very low startup time: runs the 69000 tests of the 
**[ECMAScript Test Suite](https://github.com/tc39/test262)** in about 95 seconds on a
single core of a desktop PC. The complete life cycle of a runtime instance 
completes in less than 300 microseconds.
- Almost complete **[ES2020](https://tc39.github.io/ecma262/)** support including 
modules, asynchronous generators and full Annex B support (legacy web 
compatibility).
- Passes nearly 100% of the 
**[ECMAScript Test Suite](https://github.com/tc39/test262)** tests when selecting the 
ES2020 features.
- Can compile Javascript sources to executables with no external dependency.
- Garbage collection using reference counting (to reduce memory usage and have 
deterministic behavior) with cycle removal.
- Mathematical extensions: **BigDecimal**, **BigFloat**, **operator overloading**, 
**bigint mode**, **math mode**.
- Command line interpreter with contextual colorization implemented in Javascript.
- Small built-in standard library with **C** library wrappers.

## Building

---

### Building on Windows

---
 
### Building on Unix-like platform

---

#### Prerequisistes to build on Linux

---

#### Prerequisites to build on macOS

---

### Build instructions

---

## References

---

## Team

### Nicola Del Gobbo

<https://github.com/NickNaso/>

<https://www.npmjs.com/~nicknaso>

<https://twitter.com/NickNaso>

## Acknowledgements

Thank you to all people that encourage me every day.

## License

Licensed under [Apache license V2](./LICENSE)
