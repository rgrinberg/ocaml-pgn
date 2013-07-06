
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
  color : color;
}

type board (* abstract for now *)

type coord

type game_state = {
  board: board;
  white_castled: bool;
  black_castled: bool;
  turn: color;
  en_passent : coord array;
  halfmove_clock: int;
}

let evaluate _ = failwith "TODO"
