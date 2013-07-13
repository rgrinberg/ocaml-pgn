open Core.Std 
open Str

exception Invalid_fen of string

exception Invalid_castling_rights of string

let color_of_str s = 
  let open Game.Color in
  if s = "w" then White 
  else if s = "b" then Black
  else raise (Invalid_fen s)

module Castling = struct
  let valid_castling_rights s =
    let re = Str.regexp "-\\|K?Q?k?q?"
    in Str.string_match re s 0

  let castle_of_c = function
    | 'K' | 'k' -> Game.Castling.K
    | 'Q' | 'q' -> Game.Castling.Q
    | _ -> assert false

  let castling_of_str s = 
    if not (valid_castling_rights s) then raise (Invalid_castling_rights s);
    let return ~white ~black =
      object
        method white = white
        method black = black
      end
    in
    let open Game.Castling in
    match s with
    | "-" -> return ~white:Both ~black:Both
    | _ -> 
      let (white, black) = (ref Both, ref Both) in
      s |> String.iter ~f:(fun c -> 
          let color = if Char.is_uppercase c then white else black in
          color := Game.Castling.(!color - (castle_of_c c)));
      let (white, black) = (!white, !black) in
      return ~white ~black
end

let parse_board str = failwith "TODO"

let parse_en_passent = function
  | "-" -> None
  | s -> Some (Algebraic.(s |> of_string |> to_board_coord))

let to_game str = 
  match String.split str ~on:' ' with
  | pieces::active::castling::en_passent::halfmove::fullmove::[] ->
    let board = parse_board pieces in
    let turn = color_of_str active in
    let castling = Castling.castling_of_str castling in
    let halfmove_clock = Int.of_string halfmove in
    let fullmove_clock = Int.of_string fullmove in
    let en_passent = parse_en_passent en_passent in
    Game.create ~board ~white_castled:castling#white
      ~black_castled:castling#black ~turn ~en_passent ~halfmove_clock
      ~fullmove_clock
  | _ -> raise (Invalid_fen str)

let of_game _ = failwith "TODO"
