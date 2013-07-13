open OUnit
open Chess

let fen_start = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

let game = Chess.Fen.to_game fen_start
