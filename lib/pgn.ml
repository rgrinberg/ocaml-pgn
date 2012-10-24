(*open Batteries*)
(*contains all the type defintions for games*)

let (|>) g f = f g

include Syntax

exception Inconsistent_result

(*
 *some games have a result metadata element and another result at the
 *end of every game. Make sure that these 2 values match as a sanity
 *check and get rid of the redundant one
 *)

let mdata_value metadata ~key =
  try Some(metadata |> List.assoc key)
  with Not_found -> None

let remove_result mdata = mdata |> List.remove_assoc "result"

let clean_up_game ( { metadata; result; _ } as g) =
  match metadata, result with
  (*
   *case 1 is when we possible have 2 results so we must make them match
   *and memove the redundant result from metadata
   *)
  | Some(mdata), Some(result) -> begin
    match mdata_value mdata ~key:"result" with
    | None -> g
    | Some(res) -> 
        let new_res = result_of_string res in
        if result = new_res then (*everything is consistent*)
          (*update duplicate result from metadata*)
          {g with metadata=Some(remove_result mdata) }
        else raise Inconsistent_result
    end
  (*
   *case 2 is when we have a result in metadata but not at the end of the game
   *so we remove that metadata element and transfer it into result
   *)
  | Some(mdata), None -> begin
      match mdata_value mdata ~key:"result" with
      | None -> g
      | Some(res) ->
          {g with result=Some(res |> result_of_string);
           metadata=Some(remove_result mdata) }
    end
  | _, _ -> g

let clean_up_games gs = gs |> List.map clean_up_game

let parse_of_lx lx = Pgn_parser.games Pgn_lexer.pgn lx

let parse_raw_channel channel = channel |> Lexing.from_channel |> parse_of_lx

let parse_raw_file f = parse_raw_channel (open_in f)

let parse_of_str s = s |> Lexing.from_string |> parse_of_lx |> clean_up_games

let parse_of_file f = f |> parse_raw_file |> clean_up_games

let parse_of_channel ch = ch |> parse_raw_channel |> clean_up_games
