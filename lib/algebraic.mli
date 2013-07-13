type rank = int with sexp

type file = [`a | `b | `c | `d | `e | `f | `g | `h] with sexp

type algebraic_coord = file * rank with sexp

val of_string : string -> algebraic_coord

val of_board_coord : Board.coord -> algebraic_coord

val to_board_coord : algebraic_coord -> Board.coord

val rank_of_int : int -> int

val string_of_file : file -> string

val files : file list

(** strongly typed moves *)
module Move : sig
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
