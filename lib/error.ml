type t = [ `Missing_env_var of string | `Server_error of exn ]

let to_string = function
  | `Missing_env_var s ->
      Printf.sprintf
        "The environment variable %S is needed, but could not be found in your \
         environment.\n\
         Hint: Try setting it and run the program again." s
  | `Server_error exn ->
      Printf.sprintf
        "Marksman LSP server encountered an internal error and is about to exit.\n\
         %s"
        (Printexc.to_string exn)

let missing_env env = `Missing_env_var env
let server_error exn = `Server_error exn
