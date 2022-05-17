open Jsonrpc
open Lsp.Io
open Lsp.Types

module Sync_io = struct
  type 'a t = unit -> 'a

  let return a () = a
  let raise exn () = raise exn

  module O = struct
    let ( let+ ) a f () = f (a ())
    let ( let* ) a f () = f (a ()) ()
  end
end

module Sync_chan = struct
  type input = in_channel
  type output = out_channel

  let read_line input () =
    try input_line input |> Option.some with End_of_file -> None

  let read_exactly input size () =
    try really_input_string input size |> Option.some with End_of_file -> None

  let write output string () =
    output_string output string;
    flush output
end

module Sync_jsonrpc = Make (Sync_io) (Sync_chan)

let not_implemented () =
  let err =
    Response.Error.
      { code = Code.RequestFailed; message = "Not implemented"; data = None }
  in
  raise (Response.Error.E err)

let ignore_noti _ = ()

let handle_initialize (_pars : InitializeParams.t) =
  let serverInfo = InitializeResult.create_serverInfo ~name:"Marksman" () in
  let capabilities = ServerCapabilities.create () in
  InitializeResult.create ~capabilities ~serverInfo ()

let handle_req (type a) (req : a Lsp.Client_request.t) =
  let open Lsp.Client_request in
  match[@warning "-4"] req with
  | Initialize pars -> handle_initialize pars |> yojson_of_result req
  | Shutdown -> () |> yojson_of_result req
  | _ -> not_implemented ()

let process_req (req : Message.request) =
  let open Lsp.Client_request in
  let client_req = of_jsonrpc req in
  match client_req with
  | Ok req -> ( match req with E req -> handle_req req)
  | Error e ->
      let err =
        Response.Error.{ code = Code.ParseError; message = e; data = None }
      in
      raise (Response.Error.E err)

let process_noti (_noti : Message.notification) = ignore_noti
let process_resp (_resp : Response.t) = not_implemented

let process_packet in_ch out_ch () =
  let packet = Sync_jsonrpc.read in_ch () in
  match packet with
  | Some packet ->
      let open Message in
      (match packet with
      | Message { id = Some id; method_; params } ->
          (* Process request *)
          let req = { id; method_; params } in
          let response = process_req req in
          let response = Response (Response.ok id response) in
          Sync_jsonrpc.write out_ch response ()
      | Message { id = None; method_; params } ->
          (* Process notification *)
          let noti = { id = (); method_; params } in
          process_noti noti ()
      | Response resp ->
          (* Process response *)
          process_resp resp ());
      true
  | None -> false

let run_loop () =
  let in_ch = stdin in
  let out_ch = stdout in
  Logs.info (fun m -> m "Starting Marksman LSP server");
  let rec loop () =
    let result = process_packet in_ch out_ch () in
    if result then loop () else ()
  in
  loop ()
