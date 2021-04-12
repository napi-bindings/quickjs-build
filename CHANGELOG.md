# quickjs-build changelog

## 2021-04-12 Version 5.2.0, @NickNaso

### Notable changes

- Added executable for `run-test262`.
- Auto source generation.

### Commits

* [[`105860f2d1`](https://github.com/napi-bindings/quickjs-build/commit/105860f2d1)] - Some little fixes on documentations. (NickNaso)
* [[`3788bef240`](https://github.com/napi-bindings/quickjs-build/commit/3788bef240)] - Create LICENSE (Nicola Del Gobbo)
* [[`fd7ca724ae`](https://github.com/napi-bindings/quickjs-build/commit/fd7ca724ae)] - Merge pull request #8 from gengjiawen/feat/test-262 (Nicola Del Gobbo)
* [[`6614794560`](https://github.com/napi-bindings/quickjs-build/commit/6614794560)] - Merge pull request #7 from gengjiawen/feature/atuo (Nicola Del Gobbo)

## 2021-04-10 Version 5.1.0, @NickNaso

### Notable changes

- Added executable for `quickjs` and `qjsc`.

### Commits

* [[`0b46a3f067`](https://github.com/napi-bindings/quickjs-build/commit/0b46a3f067)] - Prepare new release 5.1.0. (NickNaso)
* [[`c9ab43c489`](https://github.com/napi-bindings/quickjs-build/commit/c9ab43c489)] - Merge pull request #6 from gengjiawen/feat/binary (Nicola Del Gobbo)
* [[`97fe3599bf`](https://github.com/napi-bindings/quickjs-build/commit/97fe3599bf)] - use mingw on windows (Jiawen Geng)
* [[`c6719fecd5`](https://github.com/napi-bindings/quickjs-build/commit/c6719fecd5)] - **feat**: add quickjs and qjsc (Jiawen Geng)

## 2021-03-28 Version 5.0.0, @NickNaso

### Notable changes

- Fixed the build on *nix systems.
- QuickJS version 2021-03-27.

### QuickJS changes:

- Faster Array.prototype.push and Array.prototype.unshift.
- Added JS_UpdateStackTop().
- Fixed Windows console.
- Misc bug fixes.

### Commits

* [[`222c1964d2`](https://github.com/napi-bindings/quickjs-build/commit/222c1964d2)] - Prepare release for version 2021-03-27. (Nicola Del Gobbo)
* [[`db6da63495`](https://github.com/napi-bindings/quickjs-build/commit/db6da63495)] - Fixed build on linux. (Nicola Del Gobbo)
* [[`c04a298c35`](https://github.com/napi-bindings/quickjs-build/commit/c04a298c35)] - Prepare new version 2021-03-27. (NickNaso)

## 2020-11-08 Version 4.0.0, @NickNaso

### Notable changes

- QuickJS version 2020-11-08.

### QuickJS changes

- Improved function parameter initializers.
- Added `std.setenv()`, `std.unsetenv()` and `std.getenviron()`.
- Added JS_EvalThis().
- Misc bug fixes.

### Commits

* [[`693ec349bc`](https://github.com/napi-bindings/quickjs-build/commit/693ec349bc)] - Prepare new version 2020-11-08. (NickNaso)

## 2020-09-10 Version 3.0.0, @NickNaso

### Notable changes

- Update the assets for the release only when the release has been published.
- QuickJS version 2020-09-06.

### QuickJS changes

- Added logical assignment operators.
- Added IsHTMLDDA support.
- Faster for-of loops.
- os.Worker now takes a module filename as parameter.
- qjsc: added -D option to compile dynamically loaded modules or workers.
- Misc bug fixes.

### Commits

* [[`305934fc7e`](https://github.com/napi-bindings/quickjs-build/commit/305934fc7e)] - Prepare new version 2020-09-06. (NickNaso)
* [[`46a395c6ad`](https://github.com/napi-bindings/quickjs-build/commit/46a395c6ad)] - Update quickjs-build.yml (Nicola Del Gobbo)

## 2020-09-04 Version 2.0.0, @NickNaso

### Notable changes

- QuickJS version 2020-07-05.

### QuickJS changes

- Modified JS_GetPrototype() to return a live value.
- REPL: support unicode characters larger than 16 bits.
- Added os.Worker.
- Improved object serialization.
- Added std.parseExtJSON.
- Misc bug fixes.

### Commits

* [[`3f68062b99`](https://github.com/napi-bindings/quickjs-build/commit/3f68062b99)] - Prepare new version 2020-07-05. (NickNaso)

## 2020-06-08 Version 1.0.0, @NickNaso

### Notable changes

- Initial implementation for the project.
- QuickJS version 2020-07-05.

### Commits

* [[`b25571e2e6`](https://github.com/napi-bindings/quickjs-build/commit/b25571e2e6)] - Added changelog. (NickNaso)
* [[`a1c5a374d2`](https://github.com/napi-bindings/quickjs-build/commit/a1c5a374d2)] - Added code of conduct. (NickNaso)
* [[`59738019be`](https://github.com/napi-bindings/quickjs-build/commit/59738019be)] - Remove unused parameters. (NickNaso)
* [[`c96ed22f3f`](https://github.com/napi-bindings/quickjs-build/commit/c96ed22f3f)] - Added buil instructions for unix-like systems. (NickNaso)
* [[`ba204590fa`](https://github.com/napi-bindings/quickjs-build/commit/ba204590fa)] - Added references section. (NickNaso)
* [[`9a7344fbe5`](https://github.com/napi-bindings/quickjs-build/commit/9a7344fbe5)] - Added build instruction for Windows. (NickNaso)
* [[`cb575c3d52`](https://github.com/napi-bindings/quickjs-build/commit/cb575c3d52)] - Excluded build folder. (NickNaso)
* [[`ed3ec16353`](https://github.com/napi-bindings/quickjs-build/commit/ed3ec16353)] - Base instruction to build quickjs. (NickNaso)
* [[`56e0695c0b`](https://github.com/napi-bindings/quickjs-build/commit/56e0695c0b)] - Merge branch 'master' of https://github.com/napi-bindings/quickjs-build (NickNaso)
* [[`568d0054c8`](https://github.com/napi-bindings/quickjs-build/commit/568d0054c8)] - Some format sugar. (NickNaso)
* [[`e3c3f93b99`](https://github.com/napi-bindings/quickjs-build/commit/e3c3f93b99)] - Update README.md (Nicola Del Gobbo)
* [[`2c240fbac6`](https://github.com/napi-bindings/quickjs-build/commit/2c240fbac6)] - Added introduction on readme. (NickNaso)
* [[`2b75403d2b`](https://github.com/napi-bindings/quickjs-build/commit/2b75403d2b)] - Added badges. (NickNaso)
* [[`a2b771e731`](https://github.com/napi-bindings/quickjs-build/commit/a2b771e731)] - Handle release event. (NickNaso)
* [[`17b872447a`](https://github.com/napi-bindings/quickjs-build/commit/17b872447a)] - Fixed cflags for windows. (NickNaso)
* [[`4a4539f0f9`](https://github.com/napi-bindings/quickjs-build/commit/4a4539f0f9)] - Added cflag for windows. (NickNaso)
* [[`ad65bbbf3a`](https://github.com/napi-bindings/quickjs-build/commit/ad65bbbf3a)] - Remove unnecessary commands. (NickNaso)
* [[`c03f57309b`](https://github.com/napi-bindings/quickjs-build/commit/c03f57309b)] - Fixed artifact name on macOS. (NickNaso)
* [[`d754d944d3`](https://github.com/napi-bindings/quickjs-build/commit/d754d944d3)] - Fixed artifacts. (NickNaso)
* [[`f50c74ab7d`](https://github.com/napi-bindings/quickjs-build/commit/f50c74ab7d)] - Fixed typo. (NickNaso)
* [[`97d4081a0c`](https://github.com/napi-bindings/quickjs-build/commit/97d4081a0c)] - Print artifacts. (NickNaso)
* [[`4cf28567a7`](https://github.com/napi-bindings/quickjs-build/commit/4cf28567a7)] - Fixed compiler options. (NickNaso)
* [[`279620809a`](https://github.com/napi-bindings/quickjs-build/commit/279620809a)] - Fixed configurations. (NickNaso)
* [[`98a8f91de8`](https://github.com/napi-bindings/quickjs-build/commit/98a8f91de8)] - Parametric value for compiler. (NickNaso)
* [[`88383ad863`](https://github.com/napi-bindings/quickjs-build/commit/88383ad863)] - Comment for unused parameters. (NickNaso)
* [[`586b97de5e`](https://github.com/napi-bindings/quickjs-build/commit/586b97de5e)] - Fixed path compiler. (NickNaso)
* [[`c3c1ab64f7`](https://github.com/napi-bindings/quickjs-build/commit/c3c1ab64f7)] - Fixed path. (NickNaso)
* [[`4e634e4f81`](https://github.com/napi-bindings/quickjs-build/commit/4e634e4f81)] - Fixed path. (NickNaso)
* [[`a3c74cdfb8`](https://github.com/napi-bindings/quickjs-build/commit/a3c74cdfb8)] - Fixed compiler installartion for windows. (NickNaso)
* [[`d0a67ef816`](https://github.com/napi-bindings/quickjs-build/commit/d0a67ef816)] - List compiler folder. (NickNaso)
* [[`6a13e6d0dd`](https://github.com/napi-bindings/quickjs-build/commit/6a13e6d0dd)] - List root folders. (NickNaso)
* [[`bf5865b896`](https://github.com/napi-bindings/quickjs-build/commit/bf5865b896)] - Fixed cmake options. (NickNaso)
* [[`ede84d97d5`](https://github.com/napi-bindings/quickjs-build/commit/ede84d97d5)] - Added cmake options. (NickNaso)
* [[`9c01856429`](https://github.com/napi-bindings/quickjs-build/commit/9c01856429)] - Extract compiler. (NickNaso)
* [[`9fdff3ef87`](https://github.com/napi-bindings/quickjs-build/commit/9fdff3ef87)] - Remove build filder. (NickNaso)
* [[`f2aa910713`](https://github.com/napi-bindings/quickjs-build/commit/f2aa910713)] - Install dependencies for windows. (NickNaso)
* [[`07fa5a545f`](https://github.com/napi-bindings/quickjs-build/commit/07fa5a545f)] - Install windows depencencies. (NickNaso)
* [[`391c51a1e0`](https://github.com/napi-bindings/quickjs-build/commit/391c51a1e0)] - Install dependencies on windows. (NickNaso)
* [[`cebb8a2f8b`](https://github.com/napi-bindings/quickjs-build/commit/cebb8a2f8b)] - Install dependencies for windows. (NickNaso)
* [[`c85dfe9e77`](https://github.com/napi-bindings/quickjs-build/commit/c85dfe9e77)] - Install dependencies on windows. (NickNaso)
* [[`fc9b365a8e`](https://github.com/napi-bindings/quickjs-build/commit/fc9b365a8e)] - Install dependencies on Windows. (NickNaso)
* [[`ef53415ff6`](https://github.com/napi-bindings/quickjs-build/commit/ef53415ff6)] - Install dependencies on windows. (NickNaso)
* [[`86469b3b15`](https://github.com/napi-bindings/quickjs-build/commit/86469b3b15)] - Install windows dependencies. (NickNaso)
* [[`568fd88755`](https://github.com/napi-bindings/quickjs-build/commit/568fd88755)] - Install Windows dependencies. (NickNaso)
* [[`345b03ae35`](https://github.com/napi-bindings/quickjs-build/commit/345b03ae35)] - Install windows dependencies. (NickNaso)
* [[`6c6494ed59`](https://github.com/napi-bindings/quickjs-build/commit/6c6494ed59)] - Install Windows dependencies. (NickNaso)
* [[`a07b8e4540`](https://github.com/napi-bindings/quickjs-build/commit/a07b8e4540)] - Install depencendies for WIndows. (NickNaso)
* [[`afe92477ed`](https://github.com/napi-bindings/quickjs-build/commit/afe92477ed)] - Re enable windows on matrix. (NickNaso)
* [[`3092849294`](https://github.com/napi-bindings/quickjs-build/commit/3092849294)] - Remove unnecessary steps. (NickNaso)
* [[`84c9159870`](https://github.com/napi-bindings/quickjs-build/commit/84c9159870)] - Remove windows from matrix (NickNaso)
* [[`34049bf0cf`](https://github.com/napi-bindings/quickjs-build/commit/34049bf0cf)] - Remove unnecessary folders. (NickNaso)
* [[`24ea136acf`](https://github.com/napi-bindings/quickjs-build/commit/24ea136acf)] - Cleanup. (NickNaso)
* [[`3b3680bfb4`](https://github.com/napi-bindings/quickjs-build/commit/3b3680bfb4)] - Cleanup. (NickNaso)
* [[`5162fb2908`](https://github.com/napi-bindings/quickjs-build/commit/5162fb2908)] - Added upload artifacts. (NickNaso)
* [[`84e1c5f2d8`](https://github.com/napi-bindings/quickjs-build/commit/84e1c5f2d8)] - Change working diorectory on prepare artifacts. (NickNaso)
* [[`98e3e24159`](https://github.com/napi-bindings/quickjs-build/commit/98e3e24159)] - Prepare artifacts. (NickNaso)
* [[`bfaf01dc51`](https://github.com/napi-bindings/quickjs-build/commit/bfaf01dc51)] - Added script to configure, to build and to prepare. (NickNaso)
* [[`5b6c19c44f`](https://github.com/napi-bindings/quickjs-build/commit/5b6c19c44f)] - Install dependecies for macOS. (NickNaso)
* [[`159f61a954`](https://github.com/napi-bindings/quickjs-build/commit/159f61a954)] - Install dependencies on Windows. (NickNaso)
* [[`a2fc3018ef`](https://github.com/napi-bindings/quickjs-build/commit/a2fc3018ef)] - Install dependecies for Linux. (NickNaso)
* [[`521f4ee63f`](https://github.com/napi-bindings/quickjs-build/commit/521f4ee63f)] - Scaffolding to handle the dependencies installation. (NickNaso)
* [[`21f2d7466b`](https://github.com/napi-bindings/quickjs-build/commit/21f2d7466b)] - Ognore .vscode and .idea folders. (NickNaso)
* [[`6bbda2152b`](https://github.com/napi-bindings/quickjs-build/commit/6bbda2152b)] - Update quickjs-build.yml (Nicola Del Gobbo)
* [[`889ebffe4f`](https://github.com/napi-bindings/quickjs-build/commit/889ebffe4f)] - Update quickjs-build.yml (Nicola Del Gobbo)
* [[`376b7ee533`](https://github.com/napi-bindings/quickjs-build/commit/376b7ee533)] - Update quickjs-build.yml (Nicola Del Gobbo)
* [[`fd40c2b0ea`](https://github.com/napi-bindings/quickjs-build/commit/fd40c2b0ea)] - Update README.md (Nicola Del Gobbo)
* [[`eb1e0edf86`](https://github.com/napi-bindings/quickjs-build/commit/eb1e0edf86)] - Update README.md (Nicola Del Gobbo)
* [[`df2799b9ab`](https://github.com/napi-bindings/quickjs-build/commit/df2799b9ab)] - Update quickjs-build.yml (Nicola Del Gobbo)
* [[`d5d122297f`](https://github.com/napi-bindings/quickjs-build/commit/d5d122297f)] - Update quickjs-build.yml (Nicola Del Gobbo)
* [[`58bf4b7d14`](https://github.com/napi-bindings/quickjs-build/commit/58bf4b7d14)] - Update quickjs-build.yml (Nicola Del Gobbo)
* [[`876cebe69e`](https://github.com/napi-bindings/quickjs-build/commit/876cebe69e)] - Rename c-cpp.yml to quickjs-build.yml (Nicola Del Gobbo)
* [[`378649639f`](https://github.com/napi-bindings/quickjs-build/commit/378649639f)] - Update c-cpp.yml (Nicola Del Gobbo)
* [[`b01ba4b8d2`](https://github.com/napi-bindings/quickjs-build/commit/b01ba4b8d2)] - Update c-cpp.yml (Nicola Del Gobbo)
* [[`65f4a05f0b`](https://github.com/napi-bindings/quickjs-build/commit/65f4a05f0b)] - Update c-cpp.yml (Nicola Del Gobbo)
* [[`526444b3f9`](https://github.com/napi-bindings/quickjs-build/commit/526444b3f9)] - Initial set for build the project. (Nicola Del Gobbo)
* [[`ea73f2c78e`](https://github.com/napi-bindings/quickjs-build/commit/ea73f2c78e)] - initial commit for the project. (NickNaso)
* [[`a6cb06817f`](https://github.com/napi-bindings/quickjs-build/commit/a6cb06817f)] - Initial commit (Nicola Del Gobbo)
