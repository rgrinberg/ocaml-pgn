%{
  open Syntax
%}

%token EOF
%token LBRACK RBRACK
%token LCURLY RCURLY
%token BAD_TOKEN
%token <string>MOVE
%token <string>LITERAL
%token <string>STRING
%token <string>RESULT

%start game
%start games
%type <Syntax.game list> games
%type <Syntax.metadata > metadatas
%type <Syntax.moves> moves
%type <Syntax.move> move
%type <Syntax.game> game

%%

result:
  | RESULT { result_of_string $1 }

metadata:
  | LBRACK LITERAL STRING RBRACK { create_metadata ~key:$2 ~value:$3 }

metadatas:
  | metadata metadatas { $1::$2 }
  | metadata { [$1] }

move:
  | MOVE { $1 }

moves:
  | move moves { $1::$2 }
  | move { [$1] }

game:
  | metadatas moves result { { metadata=Some($1); moves=$2; result=Some($3) } }
  | moves result { { metadata=None; moves=$1; result=Some($2) } }
  | metadatas moves { { metadata=Some($1); moves=$2; result=None } }

games: 
  | game games { $1::$2 }
  | error games { $2 }
  | game { [$1] }

%%
