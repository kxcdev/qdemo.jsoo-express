#!/bin/bash
echo ">>> uname -a"
uname -a

echo && echo ">>> pwd"
pwd

echo && echo ">>> yarn --version"
(command -v yarn &> /dev/null && echo "yarn: $(yarn --version)") || echo "yarn not available"

echo && echo ">>> ocaml, dune, opam, js_of_ocaml version"
(command -v ocamlc &> /dev/null && echo "ocaml: $(ocamlc --version)") || echo "ocamlc not available"
(command -v dune &> /dev/null && echo "dune: $(dune --version)") || echo "dune not available"
(command -v opam &> /dev/null && echo "opam: $(opam --version)") || echo "opam not available"
(command -v js_of_ocaml &> /dev/null && echo "js_of_ocaml: $(js_of_ocaml --version)") || echo "js_of_ocaml not available"

echo && echo ">>> git --version"
(command -v git &> /dev/null && echo "git: $(git --version)") || echo "git not available"

echo && echo ">>> git status"
git show HEAD^..HEAD --stat || git show HEAD --stat

echo && echo ">>> git ls-files"
git ls-files
