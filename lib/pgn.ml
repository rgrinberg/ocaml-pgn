include Pgn_types

exception Inconsistent_result

module Mdata = struct
  let mdata_value_exn metadata ~key = metadata |> List.assoc key

  let get_exn { metadata; _ } ~key = 
    match metadata with 
    | None -> raise Not_found
    | Some(m) -> mdata_value_exn m ~key:(String.lowercase key)

  let get g ~key = try Some(get_exn g ~key) with Not_found -> None

  let mdata_value metadata ~key =
    try Some(mdata_value_exn metadata ~key)
    with Not_found -> None

  let remove_result mdata = mdata |> List.remove_assoc "result"

  let result { result; _ } = result
end

(* some games have a result metadata element and another result at the
   end of every game. Make sure that these 2 values match as a sanity
   check and get rid of the redundant one *)

let clean_up_game ( { metadata; result; _ } as g) =
  match metadata, result with
  (* case 1 is when we possible have 2 results so we must make them
     match and memove the redundant result from metadata *)
  | Some(mdata), Some(result) -> begin
      match Mdata.get g ~key:"result" with
      | None -> g
      | Some(res) -> 
        let new_res = result_of_string res in
        if result = new_res then (* everything is consistent *)
          (* update duplicate result from metadata *)
          {g with metadata=Some(Mdata.remove_result mdata) }
        else raise Inconsistent_result
    end
  (* case 2 is when we have a result in metadata but not at the end of
     the game so we remove that metadata element and transfer it into
     result *)
  | Some(mdata), None -> begin
      match Mdata.get g ~key:"result" with
      | None -> g
      | Some(res) ->
        {g with result=Some(res |> result_of_string);
                metadata=Some(Mdata.remove_result mdata) }
    end
  | _, _ -> g

(*in case clean_up_game fails or unnecessary these routines can be
  used*)
module Raw = struct
  let parse_lx lx           = Pgn_parser.games Pgn_lexer.pgn lx
  let parse_channel channel = channel |> Lexing.from_channel |> parse_lx
  let parse_file f          = parse_channel (open_in f)
  let parse_str s           = s |> Lexing.from_string |> parse_lx
end

let clean_up_games gs = 
  let rec loop acc = function
    | [] -> List.rev acc
    | x::xs ->
      try loop ((clean_up_game x)::acc) xs
      with Inconsistent_result -> loop acc xs
  in loop [] gs

let moves { moves; _ } = moves

(*main parsing routines*)
let parse_str s      = s |> Raw.parse_str |> clean_up_games
let parse_file ~path = path |> Raw.parse_file |> clean_up_games
let parse_channel ch = ch |> Raw.parse_channel|> clean_up_games
