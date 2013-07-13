type rank = int with sexp

type file = [`a | `b | `c | `d | `e | `f | `g | `h] with sexp

type algebraic_coord = file * rank with sexp

val of_string : string -> algebraic_coord

val of_board_coord : Board.coord -> algebraic_coord

val to_board_coord : algebraic_coord -> Board.coord

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
    | Move of Piece.t * rank * file
    | FullMove of Piece.t * rank * file * rank * file with sexp
end
