open Cmdliner

let cmds = [ Cmd_hello.cmd ]

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
