#ocaml-pgn

Ocaml-pgn is a simple library for parsing (Nothing else) pgn files.
Currently, the only requirement to use this library is OCaml. However,
oasis 0.3 is also required to build/install easily and oUnit is required
to run the test suite.

This library does not indend to be a general purpose pgn parsing lib
because my own needs require only a subset of the full features. Here
are the limitations:

* All comments/annotations/side lines are ignored. Only the main line is parsed
* Computer annotations ($x) are stripped
* No move/metadata validation/conversion of any kind
* Error handling for incorrect pgn files is bad. (Expect failure on the whole
  pgn file if a single game cannot be parsed) 
* no FEN support
* No pgn writing support
* All metadata (except the result) is treated as a string
* Annotations markers are matched in a "lax" way. For example: { this is
  a valid annotations ) -- on my todo list however

### Installation:
```
oasis setup
ocaml setup.ml -all
ocaml setup.ml -install # might require sudo
```
### Usage (from the top level):
```
#require "pgn";;
let g = List.hd (Pgn.parse_file "~/fischer-spassky.pgn");;
(*you can pattern match on g if you want to make exceptions aren't thrown*)
let event = Pgn.Mdata.get_exn g ~key:"event";;
let result = Pgn.Mdata.result_exn g;;
let moves = g.Pgn.moves;;
```

