open Core.Std

type rank = int with sexp

type file = [`a | `b | `c | `d | `e | `f | `g | `h] with sexp

let file_to_int = function
  | `a -> 0
  | `b -> 1
  | `c -> 2
  | `d -> 3
  | `e -> 4
  | `f -> 5
  | `g -> 6
  | `h -> 7

let file_of_int = function
  | 0 -> `a
  | 1 -> `b
  | 2 -> `c
  | 3 -> `d
  | 4 -> `e
  | 5 -> `f
  | 6 -> `g
  | 7 -> `h
  | _ -> invalid_arg "file_of_int"

let file_of_char = function
  | 'a' -> `a
  | 'b' -> `b
  | 'c' -> `c
  | 'd' -> `d
  | 'e' -> `e
  | 'f' -> `f
  | 'g' -> `g
  | 'h' -> `h
  | x -> invalid_arg ("Not a file " ^ (String.of_char x))

let rank_of_int x = 8 - x

type algebraic_coord = file * rank with sexp

let of_string s = 
  try
    let file = file_of_char s.[0] in
    let rank = Char.to_int s.[1] in
    (file, rank)
  with Invalid_argument _ -> (* in case out of bounds *)
    invalid_arg ("Bad algebraic coordinate: " ^ s)

let of_board_coord (file, rank) = 
  (file_of_int file, rank_of_int rank) (* 1,4 -> e7 *)

let to_board_coord alg_coord = failwith "TODO"

(** strongly typed moves *)
module Move = struct
  (* some of these are duplicates for the purpose of making it easier to
     specify moves *)
  type t =
    | ShortCastle
    | LongCastle
    | Pawn of file * rank
    | PawnCapture of file * file
    | Promotion of Piece.t * [`Initial of file] * [`Final of file]
    | Move of Piece.t * file * rank
    | FullMove of Piece.t * file * rank * file * rank with sexp
end
