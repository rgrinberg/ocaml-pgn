{
  Printexc.record_backtrace true
  open Syntax
  open Pgn_parser
  open Lexing
  exception Unclosed_comments
  let unsafe_list_unpack = function
    | x::xs -> (x, xs)
    | [] -> assert false
}

let move = ['a'-'z' 'A'-'Z' '0'-'9' '-' '?' '!' '+' '#']+

let space = [' ' '\t' '\n' '\r']

rule pgn = parse
  | '[' { LBRACK } (* is it possible to have comments start with this char? *)
  | ']' { RBRACK }
  | '(' { comments 0 ['('] lexbuf }
  | '{' { comments 0 ['{'] lexbuf }
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

(* context denotes the type of delimiter we use for comments in the current
 * scope. If the closing delimiter does not match the context then we throw
 * an error *)

and comments level contexts = parse
  | ')'	{
          let (context, rest) = unsafe_list_unpack contexts in
          if context = '(' then
            if level = 0 then pgn lexbuf
            else comments (level-1) rest lexbuf
          else raise Delimiter_mismatch
		}
  | '('	{ comments (level+1) (('(')::contexts) lexbuf }
  | '}'	{
          let (context, rest) = unsafe_list_unpack contexts in
          if context = '{' then
            if level = 0 then pgn lexbuf
            else comments (level-1) rest lexbuf
          else raise Delimiter_mismatch
		}
  | '{'	{ comments (level+1) (('{')::contexts) lexbuf }
  | _		{ comments level contexts lexbuf }
  | eof		{ raise Unclosed_comments }
