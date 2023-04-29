(lang dune 3.2)
(using directory-targets 0.1)

(source
 (github kxcdev/qdemo.jsoo-express))
(bug_reports "https://github.com/kxcdev/qdemo.jsoo-express/issues")

(license private)
(maintainers "Haochen Xie <hx@kxc.io>" "KXC Members <info@kxc.io>")
(authors "Haochen Xie" "KXC Members and Contributors")

(generate_opam_files true)

(package
 (name kxcdev-qdemo-jsoo-express)
 (allow_empty)

 (synopsis "A quick demo for the Js_of_ocaml + Node.js/Express.js stack")
 (description "A quick demo for the Js_of_ocaml + Node.js/Express.js stack")

 (depends
  (js_of_ocaml (>= 4.0.0))
  (js_of_ocaml-ppx (>= 4.0.0))
  (js_of_ocaml-lwt (>= 4.0.0))
  (bisect_ppx (>= 2.7.1))
  (ocaml (>= 4.13.1))))
