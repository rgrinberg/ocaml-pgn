open OUnit

let pgn_root = "../samples"

(* Basic sanity check by parsing the simplest game *)
let g1 = List.hd (Pgn.parse_str "[one \"two\"]\n {foo} 1.e4 e5")
let test_metadata_1 () = assert_equal (Pgn.Mdata.get_exn g1 ~key:"one") "two"
let test_metadata_2 () = assert_equal (g1.Pgn.moves) ["e4";"e5"]

(*we want to check that the result of the game is being consistently parsed*)

let g2 = List.hd (Pgn.parse_str "[result \"1-0\"]\n 1.e4 e5 1-0")
let test_result_1 () = assert_equal (Pgn.Mdata.get g2 ~key:"result") None 
let test_result_2 () = Pgn.( assert_equal (Mdata.result_exn g2) (Win(White)) )

let test_fixtures = 
  "test pgn parser" >:::
    [
      "test mdata 1" >:: test_metadata_1;
      "test moves 1" >:: test_metadata_2;
      "test result 1" >:: test_result_1;
      "test result 2" >:: test_result_2;
    ]

let _ = run_test_tt ~verbose:true test_fixtures
