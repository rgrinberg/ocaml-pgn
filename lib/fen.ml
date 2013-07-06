open Core.Std 
open Str

exception Invalid_fen of string

exception Invalid_castling_rights of string

type t = string

let of_string t = t

let to_string t = t

let color_of_str s = 
  if s = "w" then Game.White 
  else if s = "b" then Game.Black
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

let piece_positions_of_string str = failwith "TODO"

let to_game str = 
  match String.split str ~on:' ' with
  | pieces::active::castling::en_passent::halfmove::fullmove::[] ->
    let pieces = piece_positions_of_string pieces in
    let turn = color_of_str active in
    let castling = Castling.castling_of_str castling in
    let halfmove_clock = Int.of_string halfmove in
    let fullmove_clock = Int.of_string fullmove in
    failwith "TODO"
  | _ -> raise (Invalid_fen str)

let of_game _ = failwith "TODO"
