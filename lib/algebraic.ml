open Core.Std

type rank = int with sexp

type file = [`a | `b | `c | `d | `e | `f | `h | `h] with sexp

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

type algebraic_coord = file * rank with sexp

let of_string s = 
  try
    let file = file_of_char s.[0] in
    let rank = Char.to_int s.[1] in
    (file, rank)
  with Invalid_argument _ -> (* in case out of bounds *)
    invalid_arg ("Bad algebraic coordinate: " ^ s)

let of_board_coord coord = failwith "TODO"

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
    | Move of Piece.t * rank * file
    | FullMove of Piece.t * rank * file * rank * file with sexp
end
