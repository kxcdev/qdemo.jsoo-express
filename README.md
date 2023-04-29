# qdemo.jsoo-express

A quick demo for the Js_of_ocaml + Node.js/Express.js stack

## Get started
- you will need to setup git submodules correctly first.
  this can usually be achieved by running `git submodule update --init`
- you may need/want to run `make init` first
- try run `make serve-main-entry`
  - which will serve the express app under `apps/main-entry`
    while the entry file being `apps/main-entry/src/main.ts`
- or `make dev-main-entry`
  - this one watches source file changes, and will rebuild and restart the
    server when changes are detected
- you can run tests with `make test`
- or `make coverage` to run tests with coverage report
  - note that we currently do not take stats on jsoo generated files
    as that would give too much false positives
