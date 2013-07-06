
type piece = 
  | Pawn
  | Knight
  | Bishop
  | Rook
  | Queen
  | King

type color = Black | White

type result = 
  | Win of color 
  | Draw

type game_piece = {
  piece : piece;
  (* put this in common *)
  color : color
}

type board (* abstract for now *)

module Castling : sig
  type t = K | Q | Both | Neither
  val (+) : t -> t -> t
  val (-) : t -> t -> t
end

type coord

type move

type state

val create : board: board ->
  white_castled:Castling.t ->
  black_castled:Castling.t ->
  turn:color ->
  en_passent: coord option ->
  halfmove_clock:int ->
  fullmove_clock:int ->
  state

val evaluate : state -> [`Finished of result | `Ongoing]
