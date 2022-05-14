(** Markdown LSP server for easy note-taking with cross-references and
    diagnostics *)

module Config = Config
module Error = Error

val greet : string -> string
(** Returns a greeting message.

    {4 Examples}

    {[
      print_endline @@ greet "Jane"
    ]} *)
