
type t = Pawn | Knight | Bishop | Rook | Queen | King with sexp

let to_string = function
  | Pawn -> "p"
  | Knight -> "n"
  | Bishop -> "b"
  | Rook -> "r"
  | Queen -> "q"
  | King -> "k"
