open Alcotest

let test_stub name () = check string "same string" name name
let suite_stub = [ ("stub", `Quick, test_stub "stub") ]
let () = Alcotest.run "marksman" [ ("Marksman", suite_stub) ]
