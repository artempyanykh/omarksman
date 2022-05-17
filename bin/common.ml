open Cmdliner

module Syntax = struct
  let ( let+ ) t f = Term.(const f $ t)
  let ( and+ ) a b = Term.(const (fun x y -> (x, y)) $ a $ b)
end

open Syntax

let envs =
  [
    Cmd.Env.info "MARKSMAN_CACHE_DIR"
      ~doc:"The directory where the application data is stored.";
    Cmd.Env.info "MARKSMAN_CONFIG_DIR"
      ~doc:"The directory where the configuration files are stored.";
  ]

let term =
  let+ log_level =
    let env = Cmd.Env.info "MARKSMAN_VERBOSITY" in
    Logs_cli.level ~docs:Manpage.s_common_options ~env ()
  in
  Fmt_tty.setup_std_outputs ();
  Logs.set_level log_level;
  Logs.set_reporter (Logs_fmt.reporter ~app:Fmt.stderr ());
  0

let error_to_code = function
  | `Missing_env_var _ -> Cmd.Exit.some_error
  | `Server_error _ -> Cmd.Exit.internal_error

let handle_errors = function
  | Ok () -> if Logs.err_count () > 0 then 3 else 0
  | Error err ->
      Logs.err (fun m -> m "%s" (Marksman.Error.to_string err));
      error_to_code err

let exits = Cmd.Exit.defaults
