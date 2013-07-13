open Core.Std
open Chess

(* not a real test, we're just eyeballing whether the position looks like
   it would fit*)
let fen_start = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

let game = Chess.Fen.to_game fen_start

let sexp = Game.sexp_of_state game

let () = printf "\nBeginning position:\n%s\n" (Sexp.to_string_hum sexp)
