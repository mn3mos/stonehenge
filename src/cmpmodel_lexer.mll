{
  open Cmpmodel_parser
  (* open Lexing *)

  exception LexError of string
}

rule tokenize = parse
| [' ' '\t' '\n'] (* also ignore newlines, not only whitespace and tabs *)
    { tokenize lexbuf }

| "data"  { MODULE_DATA }
| "alias" { ALIAS }
| "contracts"   { MODULE_CONTRACTS }
| "components"  { MODULE_COMP }
| "deployment"  { MODULE_DEPL }

| ['a'-'z''A'-'Z']+['a'-'z''A'-'Z''0'-'9']* as i    { ID i }
| '{'  { LBRACE }
| '}'  { RBRACE }
| eof  { EOF }
| _
    { raise (LexError (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }
