
type t

val of_string : string -> t

val to_string : t -> string

val to_game_state : t -> Chess.game_state

val of_game_state : Chess.game_state -> t
