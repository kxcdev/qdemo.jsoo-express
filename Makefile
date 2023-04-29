.PHONY: default clean build test coverage
.PHONY: init init-promote init-relaxed init-ci
.PHONY: post-init by-dune
.PHONY: ci-prepare ci-build ci-test

.PHONY: pack-main-entry serve-main-entry dev-main-entry
.PHONY: pack

default: node_modules build test coverage

pack: pack-main-entry
pack-main-entry: apps/main-entry/dist/main-entry-bundle.tar.gz

build: pack

test:
	dune runtest -f --no-buffer

coverage:
	rm -rf _coverage
	-dune runtest -f --instrument-with bisect_ppx --no-buffer
	@(cd _build/default && \
	  mkdir -p _coverage/ocaml/coverage-files && \
	  find . | grep -E 'bisect.+[.]coverage$$' | xargs -I{} cp {} _coverage/ocaml/coverage-files)
	@(cd _build/default && \
	  bisect-ppx-report html -o _coverage/ocaml _coverage/ocaml/coverage-files/*)
	-(cd _build/default && npx jest --coverage)
	@echo ">>> OCaml coverage:"
	@(cd _build/default && \
	  bisect-ppx-report summary _coverage/ocaml/coverage-files/*)
	cp -aP _build/default/_coverage _coverage

post-init:
	rm -rf node_modules
	cp -aP _build/default/node_modules/ node_modules/

ci-prepare: init-ci
ci-build: build pack
ci-test: test coverage

init:
	dune build @init
	$(MAKE) post-init

init-promote:
	dune build @init --auto-promote
	$(MAKE) post-init

init-relaxed:
	PURE_LOCKFILE=true dune build @init
	$(MAKE) post-init

init-ci:
	FROZEN_LOCKFILE=true dune build @init
	$(MAKE) post-init

clean:
	@echo dune build @clean
	@dune build @clean || echo "info: dune build @clean failed but not a problem"
	@echo dune clean
	@dune clean || echo "info: dune clean failed but not a problem"
	rm -rf _dist
	rm -rf _build
	rm -rf _coverage
	rm -rf node_modules

serve-main-entry: pack-main-entry by-dune
	dune build @fresh-serve apps/main-entry --no-buffer --display quiet

dev-main-entry: by-dune
	dune build apps/main-entry/_serve
	dune build -w @serve apps/main-entry --no-buffer

apps/main-entry/dist/main-entry-bundle.tar.gz: by-dune
	dune build @pack apps/main-entry/dist --no-buffer

node_modules:
	$(MAKE) init
by-dune:
