module Color : sig
  type t =
    | Black
    | White
  with sexp
end

module Piece : sig
  type t =
    | Pawn
    | Knight
    | Bishop
    | Rook
    | Queen
    | King
  with sexp
end

module Board : sig
  type 'a t = 'a option array array with sexp
  type coord = int * int with sexp
  type move = 
    | Remove of coord 
    | Move of coord * coord with sexp
  val make_move : 'a t -> move -> unit
  val create : unit -> 'a t
end

type result =
  | Win of Color.t
  | Draw
with sexp

type game_piece = {
  piece : Piece.t;
  color : Color.t;
} with sexp, fields

module Castle : sig
  type t =
    | K
    | Q
    | Both
    | Neither
  with sexp
  val (-) : t -> t -> t
end

type state = {
  board : game_piece Board.t;
  white_castle : Castle.t;
  black_castle : Castle.t;
  turn : Color.t;
  en_passent : Board.coord option;
  halfmove_clock : int;
  fullmove_clock : int;
  white_king : Board.coord;
  black_king : Board.coord;
} with sexp, fields

val create :
  board: game_piece Board.t ->
  white_castle:Castle.t ->
  black_castle:Castle.t ->
  turn:Color.t ->
  en_passent:Board.coord option ->
  halfmove_clock:int -> fullmove_clock:int -> state

val evaluate : 'a -> 'b

val ascii_board : game_piece Board.t -> string
