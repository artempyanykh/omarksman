type t = [ `Missing_env_var of string | `Server_error of exn ]

val to_string : t -> string
val missing_env : string -> t
val server_error : exn -> t
