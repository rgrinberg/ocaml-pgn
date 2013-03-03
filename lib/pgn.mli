exception Invalid_result of string
exception Delimiter_mismatch
(** thrown by the parse functions if the result in the metadata
 * does not match the result at the end of the game *)
exception Inconsistent_result

type color = Black | White
type result = Win of color | Draw
type mdata_element = string * string
type metadata = mdata_element list
type move = string
type moves = move list

type game = {
  metadata : metadata option;
  moves : moves;
  result : result option;
}

val create_metadata : key:string -> value:'a -> string * 'a

module Mdata :
  sig
    val get_exn : game -> key:string -> string
    val get : game -> key:string -> string option
    val result : game -> result option
  end

val moves : game -> moves
val parse_str : string -> game list
val parse_file : string -> game list
val parse_channel : in_channel -> game list
