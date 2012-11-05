{
  Printexc.record_backtrace true
  open Pgn_parser
  open Lexing
  exception Unclosed_comments
}

let move = ['a'-'z' 'A'-'Z' '0'-'9' '-' '?' '!' '+' '#']+

let space = [' ' '\t' '\n' '\r']

rule pgn = parse
  | '[' { LBRACK }
  | '(' { comments 0 lexbuf }
  | ']' { RBRACK }
  | '{' { comments 0 lexbuf }
  | ['a'-'z' 'A'-'Z']+ { LITERAL (lexeme lexbuf) }
  | space { pgn lexbuf }
  | '\"' [^'\"']* '\"' { 
      let str = lexeme lexbuf in
      STRING (String.sub str 1 (String.length str - 2)) }
  | ['0'-'9']+ space* '.'+ { pgn lexbuf }
  (*
   *$x where x is a number are computer annotations. for now we decide to stirp
   *them since we do not even parse variations
   *)
  | '$' ['0'-'9']* { pgn lexbuf }
  | "1/2-1/2" | "1-0" | "0-1" { RESULT (lexeme lexbuf) }
  | move+ { MOVE (lexeme lexbuf) }
  | eof { EOF }
  | _ { BAD_TOKEN }

(*
 *TODO : match comment delimiters. Right now {(}) is valid but should not be
 *)

and comments level = parse
  | ')'	{
  		  if level = 0 then pgn lexbuf
		  else comments (level-1) lexbuf
		}
  | '('	{ comments (level+1) lexbuf }
  | '}'	{
  		  if level = 0 then pgn lexbuf
		  else comments (level-1) lexbuf
		}
  | '{'	{ comments (level+1) lexbuf }
  | _		{ comments level lexbuf }
  | eof		{ raise Unclosed_comments }
