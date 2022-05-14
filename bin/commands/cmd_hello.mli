val run : name:string -> (unit, 'a) result
val doc : string
val sdocs : string
val exits : Cmdliner.Cmd.Exit.info list
val envs : Cmdliner.Cmd.Env.info list
val man : [> `P of string | `S of string ] list
val info : Cmdliner.Cmd.info
val term : int Cmdliner.Term.t
val cmd : int Cmdliner.Cmd.t
