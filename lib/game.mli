
type piece = 
  | Pawn
  | Knight
  | Bishop
  | Rook
  | Queen
  | King with sexp

type color = Black | White with sexp

type result = 
  | Win of color 
  | Draw with sexp

type game_piece = {
  piece : piece;
  (* put this in common *)
  color : color
} with sexp

type board (* abstract for now *)

module Castling : sig
  type t = K | Q | Both | Neither with sexp
  val (+) : t -> t -> t
  val (-) : t -> t -> t
end

type coord with sexp

type move with sexp

type state with sexp

val create : board: board ->
  white_castled:Castling.t ->
  black_castled:Castling.t ->
  turn:color ->
  en_passent: coord option ->
  halfmove_clock:int ->
  fullmove_clock:int ->
  state

val evaluate : state -> [`Finished of result | `Ongoing]
