open Core.Std

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
  color : color;
} with sexp

type coord = int * int with sexp

type move = coord * coord with sexp

(* we don't really pick the most efficient representation memory wise
   since it's not really the goal of this library *)

type board = game_piece option array with sexp

(* not sure if this belongs here *)
module Castling = struct
  type t = K | Q | Both | Neither with sexp
  let (+) r1 r2 = 
    match (r1, r2) with
    | K, Q | Q, K -> Both
    | x, y when x = y -> x
    | _, _ -> invalid_arg "Rights.(+)"
  (* should probably define an inverse of an element and redefine
     - in terms of the inverse. *)
  let (-) r1 r2 = 
    match (r1, r2) with
    | Neither, _ -> Neither
    | _, Both -> Neither
    | x, y -> if x = y then Neither else x
end

type state = {
  board: board;
  white_castled: Castling.t;
  black_castled: Castling.t;
  turn: color;
  en_passent : coord option;
  halfmove_clock: int;
  fullmove_clock: int;
  white_king: coord;
  black_king: coord;
} with sexp

let find_kings board = failwith "TODO"

let create ~board ~white_castled ~black_castled ~turn ~en_passent
    ~halfmove_clock ~fullmove_clock = 
  let (white_king, black_king) = find_kings board in
  { board ; white_castled ; en_passent ; black_castled ; turn ;
    halfmove_clock ; fullmove_clock ; white_king ; black_king }

let evaluate _ = failwith "TODO"
