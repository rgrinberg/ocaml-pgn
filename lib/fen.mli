
type t

val of_string : string -> t

val to_string : t -> string

val to_game : t -> Game.state

val of_game : Game.state -> t
