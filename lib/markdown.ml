module Linemap = struct
  type t = int * int Array.t

  let mk _str = [||]
end

module Text = struct
  type t = { str : string; linemap : Linemap.t }
end

module Cst = struct
  type 'a t =
    | Header of { level : int; title : string }
    | Wiki_link of { doc : string }
end

module Parsing = struct
  type string_span = { str : string; start : int; end_ : int }

  let char_in_span span pos =
    if pos < span.start || pos >= span.end_ then None else Some span.str.[pos]

  type string_cursor = { span : string_span; pos : int }

  let span_to_cursor span =
    if span.start < span.end_ then Some { span; pos = span.start } else None

  let char_at_cursor c = char_in_span c.span c.pos |> Option.get
  let parse str = str
end
