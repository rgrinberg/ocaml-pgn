open Core.Std

type 'a t = 'a option array array with sexp

(* a board is 'dumb' it doesn't know what pieces are on the board.
   It simply moves pieces from a square to another square. Multiple moves
   such as castling must be encoded as sequences of moves *)

type coord = int * int with sexp

type move =
  | Remove of coord (* for en passent only *)
  | Move of coord * coord with sexp

let make_move board = function
  | Remove(x,y) -> board.(x).(y) <- None
  | Move((x1,y1), (x2,y2)) -> begin
      board.(x2).(y2) <- board.(x1).(y1);
      board.(x1).(y1) <- None
    end

let create () = Array.make_matrix ~dimx:8 ~dimy:8 None

(* TODO implement this for find kings *)
let findi board ~f = failwith "TODO"
