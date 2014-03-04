#ocaml-pgn

Ocaml-pgn is a simple library for parsing (Nothing else) pgn files.
Currently, the only requirement to use this library is OCaml. However,
oasis 0.4 is also required to build/install easily and oUnit is
required to run the test suite.

This library does not indend to be a general purpose pgn parsing lib
because my own needs require only a subset of the full features. Here
are the limitations:

* All comments/annotations/side lines are ignored. Only the main line
  is parsed
* Computer annotations ($x) are stripped
* No move/metadata validation/conversion of any kind
* No error recovery whatsoever
* No pgn writing support
* All metadata (except the result) is treated as a string

### Installation:
```
oasis setup
ocaml setup.ml -all
ocaml setup.ml -install
```
### Usage (from the top level):

See pgn.mli for more documentation
```
#require "pgn";;
let g = List.hd (Pgn.parse_file "~/fischer-spassky.pgn");;

(*you can pattern match on g if you want to make sure exceptions
aren't thrown*)

let event = Pgn.Mdata.get_exn g ~key:"event";;
let result = Pgn.Mdata.result g;;
let moves = Pgn.moves g;;
```

