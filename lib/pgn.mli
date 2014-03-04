exception Invalid_result of string
(** This exception is thrown whenever a game contains annotations with
 * mismatched delimiters. *)
exception Delimiter_mismatch
(** thrown by the parse functions if the result in the metadata
 * does not match the result at the end of the game *)
exception Inconsistent_result

type mdata_element = string * string
type metadata = mdata_element list
type move = string
type moves = move list

type game = {
  metadata : metadata option;
  moves : moves;
  result : Game.result option;
}

(** Module to parse metadata routines *)
module Mdata :
sig
  val get_exn : game -> key:string -> string
  val get : game -> key:string -> string option
  val result : game -> Game.result option
end

(** [moves g] return the list of moves in the games. each element in the list
 * represents a ply *)
val moves : game -> moves

(** parsing routines from different sources  *)

val parse_str : string -> game list
val parse_file : path:string -> game list
val parse_channel : in_channel -> game list
