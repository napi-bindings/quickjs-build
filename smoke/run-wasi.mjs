// Runs a wasm32-wasi command module with the WASI implementation of Node.js.
//
//   node smoke/run-wasi.mjs build/wasm32-wasi/qjs-smoke.wasm [args...]
//
// The exit status is the one of the module, so this script can be used as
// CMAKE_CROSSCOMPILING_EMULATOR for the wasm32-wasi build.
import { readFile } from 'node:fs/promises';
import { WASI } from 'node:wasi';

const [file, ...args] = process.argv.slice(2);
if (!file) {
  console.error('usage: node run-wasi.mjs <module.wasm> [args...]');
  process.exit(2);
}

const wasi = new WASI({
  version: 'preview1',
  args: [file, ...args],
  env: {},
  returnOnExit: true,
});
const module = await WebAssembly.compile(await readFile(file));
const instance = await WebAssembly.instantiate(module, wasi.getImportObject());
process.exit(wasi.start(instance));
