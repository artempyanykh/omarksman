(** Markdown LSP server for easy note-taking with cross-references and
    diagnostics *)

module Config = Config
module Error = Error

val start_server : unit -> unit
(** Starts an LSP server. *)
