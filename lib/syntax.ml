exception Invalid_result of string
exception Delimiter_mismatch

type mdata_element = string * string
type metadata      = mdata_element list

type move = string
type moves = move list

open Chess

type game = {
  metadata : metadata option;
  moves    : moves;
  (*
   *we only have special handling for the result metadata because there are 2
   *ways to obtain it from a pgn file
   *)
  result   : result option }

let result_of_string = function
  | "1-0"     -> Win(White)
  | "0-1"     -> Win(Black)
  | "1/2-1/2" -> Draw
  | x         -> raise (Invalid_result x)

(*all keys are lower case*)
let create_metadata ~key ~value = (String.lowercase key, value)
