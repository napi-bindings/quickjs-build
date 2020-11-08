# quickjs-build changelog

## 2020-11-08 Version 4.0.0, @NickNaso

- improved function parameter initializers
- added `std.setenv()`, `std.unsetenv()` and `std.getenviron()`
- added JS_EvalThis()
- misc bug fixes

## 2020-09-10 Version 3.0.0, @NickNaso

- added logical assignment operators
- added IsHTMLDDA support
- faster for-of loops
- os.Worker now takes a module filename as parameter
- qjsc: added -D option to compile dynamically loaded modules or workers
- misc bug fixes

## 2020-09-04 Version 2.0.0, @NickNaso

- modified JS_GetPrototype() to return a live value
- REPL: support unicode characters larger than 16 bits
- added os.Worker
- improved object serialization
- added std.parseExtJSON
- misc bug fixes

## 2020-06-08 Version 1.0.0, @NickNaso

Initial implementation.