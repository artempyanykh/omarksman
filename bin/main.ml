open Cmdliner

module Cmd_server = struct
  let run () =
    try
      Marksman.start_server ();
      Ok ()
    with exn -> Error (Marksman.Error.server_error exn)

  (* Command line interface *)

  open Cmdliner

  let doc = "Start \"Marksman\" LSP server"
  let sdocs = Manpage.s_common_options
  let exits = Common.exits
  let envs = Common.envs

  let man =
    [
      `S Manpage.s_description;
      `P "$(tname) starts and LSP server on stdin/stdout.";
    ]

  let info = Cmd.info "server" ~doc ~sdocs ~exits ~envs ~man

  let term =
    let open Common.Syntax in
    let+ _term = Common.term in
    run () |> Common.handle_errors

  let cmd = Cmd.v info term
end

let cmds = [ Cmd_server.cmd ]

(* Command line interface *)

let doc =
  "Markdown LSP server for easy note-taking with cross-references and \
   diagnostics"

let sdocs = Manpage.s_common_options
let exits = Common.exits
let envs = Common.envs

let man =
  [
    `S Manpage.s_description;
    `P
      "Markdown LSP server for easy note-taking with cross-references and \
       diagnostics";
    `S Manpage.s_commands;
    `S Manpage.s_common_options;
    `S Manpage.s_exit_status;
    `P "These environment variables affect the execution of $(mname):";
    `S Manpage.s_environment;
    `S Manpage.s_bugs;
    `P "File bug reports at $(i,%%PKG_ISSUES%%)";
    `S Manpage.s_authors;
    `P "Artem Pianykh, $(i,https://github.com/artempyanykh)";
  ]

let default_cmd =
  let term =
    let open Common.Syntax in
    Term.ret
    @@ let+ _ = Common.term in
       `Help (`Pager, None)
  in
  let info =
    Cmd.info "marksman" ~version:"%%VERSION%%" ~doc ~sdocs ~exits ~man ~envs
  in
  (term, info)

let () =
  let default, info = default_cmd in
  let cmd_group = Cmd.group ~default info cmds in
  Stdlib.exit @@ (cmd_group |> Cmd.eval')
