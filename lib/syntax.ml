
exception Invalid_result of string

type color = Black | White

type result = 
  | Win of color 
  | Draw

type mdata_element = string * string
type metadata      = mdata_element list

type move = string
type moves = string list

type game = {
  metadata: metadata option;
  moves: moves;
  result: result option }

let result_of_string = function
  | "1-0"     -> Win(White)
  | "0-1"     -> Win(Black)
  | "1/2-1/2" -> Draw
  | x         -> raise (Invalid_result x)

(*all keys are lower case*)
let create_metadata ~key ~value = (String.lowercase key, value)
