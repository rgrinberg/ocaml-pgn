module Color : sig
  type t = Black | White with sexp
end

module Piece :
sig
  type t = Pawn | Knight | Bishop | Rook | Queen | King with sexp
end

module Board :
sig
  type t = (Piece.t option) array array with sexp
  type coord = int * int with sexp
  type move = 
    | Remove of coord 
    | Move of coord * coord with sexp
  val make_move : t -> move -> unit
  val create : dimx:int -> dimy:int -> t
end

module Algebraic : (module type of Algebraic)

type result = Win of Color.t | Draw with sexp
type game_piece = { piece : Piece.t; color : Color.t; } with sexp
module Castling :
sig
  type t = K | Q | Both | Neither with sexp
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
end
type state = {
  board : Board.t;
  white_castled : Castling.t;
  black_castled : Castling.t;
  turn : Color.t;
  en_passent : Board.coord option;
  halfmove_clock : int;
  fullmove_clock : int;
  white_king : Board.coord;
  black_king : Board.coord;
}
val find_kings : 'a -> 'b
val create :
  board:Board.t ->
  white_castled:Castling.t ->
  black_castled:Castling.t ->
  turn:Color.t ->
  en_passent:Board.coord option ->
  halfmove_clock:int -> fullmove_clock:int -> state
val evaluate : 'a -> 'b
