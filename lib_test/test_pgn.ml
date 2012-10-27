open OUnit

let pgn_root = "../samples"

let g1 = List.hd (Pgn.parse_str "[one \"two\"]\n 1.e4 e5")

let test_fixtures = 
  "test pgn parser" >:::
    [
      "test mdata 1" >:: (fun () ->
        assert_equal (Pgn.Mdata.get_exn g1 ~key:"one") "two";
      );
      "test moves 1" >:: (fun () ->
        assert_equal (g1.Pgn.moves) ["e4";"e5"];
      );
    ]

let _ = run_test_tt ~verbose:true test_fixtures
