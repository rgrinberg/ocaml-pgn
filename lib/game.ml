open Core.Std

module Color = struct
  type t = Black | White with sexp
end

module Piece = Piece

module Board = Board

type result = 
  | Win of Color.t
  | Draw with sexp

type game_piece = {
  piece : Piece.t;
  (* put this in common *)
  color : Color.t;
} with sexp

(* we don't really pick the most efficient representation memory wise
   since it's not really the goal of this library *)

(* not sure if this belongs here *)
module Castling = struct
  type t = K | Q | Both | Neither with sexp
  let (+) r1 r2 = 
    match (r1, r2) with
    | K, Q | Q, K -> Both
    | x, y when x = y -> x
    | _, _ -> invalid_arg "Rights.(+)"
  (* should probably define an inverse of an element and redefine
     - in terms of the inverse. *)
  let (-) r1 r2 = 
    match (r1, r2) with
    | Neither, _ -> Neither
    | _, Both -> Neither
    | x, y -> if x = y then Neither else x
end

type state = {
  board: game_piece Board.t;
  white_castled: Castling.t;
  black_castled: Castling.t;
  turn: Color.t;
  en_passent : Board.coord option;
  halfmove_clock: int;
  fullmove_clock: int;
  white_king: Board.coord;
  black_king: Board.coord;
} with sexp

let find_kings board =
  let (w, b) = (ref None, ref None) in
  for r = 0 to 7 do
    for f = 0 to 7 do
      match board.(r).(f) with
      | None -> ()
      | Some {piece=Piece.King; color=Color.Black} ->
        w := Some (r, f)
      | Some {piece=Piece.King; color=Color.White} ->
        b := Some (r, f)
      | Some _ -> ()
    done;
  done;
  Option.(value_exn !w, value_exn !b)

let create ~board ~white_castled ~black_castled ~turn ~en_passent
    ~halfmove_clock ~fullmove_clock = 
  let (white_king, black_king) = find_kings board in
  { board ; white_castled ; en_passent ; black_castled ; turn ;
    halfmove_clock ; fullmove_clock ; white_king ; black_king }

let ascii_square = function
  | None -> " "
  | Some {color; piece} -> 
    match color with
    | Color.Black -> piece |> Piece.to_string
    | Color.White -> piece |> Piece.to_string |> String.capitalize

let ascii_board board =
  let no_files = board
                 |> Array.mapi ~f:(fun ranki rank -> 
                     rank
                     |> Array.map ~f:ascii_square
                     |> Array.to_list
                     |> List.cons (ranki 
                                   |> Algebraic.rank_of_int
                                   |> Int.to_string)
                     |> String.concat ~sep:" | ")
                 |> Array.to_list in
  no_files @ [ 
    List.init 8 ~f:(fun _ -> "=")
    |> List.cons " "
    |> String.concat ~sep:"==="
  ; Algebraic.files
    |> List.map ~f:Algebraic.string_of_file
    |> List.cons " "
    |> String.concat ~sep:" | " ]
  |> String.concat ~sep:"\n"

let evaluate _ = failwith "TODO"
