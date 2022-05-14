(lang dune 2.0)

(name marksman)

(documentation "https://artempyanykh.github.io/marksman/")

(source
 (github artempyanykh/marksman))

(license ISC)

(authors "Artem Pianykh")

(maintainers "Artem Pianykh")

(generate_opam_files true)

(package
 (name marksman)
 (synopsis
  "Markdown LSP server for easy note-taking with cross-references and diagnostics")
 (description
  "Markdown LSP server for easy note-taking with cross-references and diagnostics")
 (depends
  (ocaml
   (>= 4.14.0))
  dune
  (alcotest :with-test)
  (odoc :with-doc)
  cmdliner
  logs
  fmt))
