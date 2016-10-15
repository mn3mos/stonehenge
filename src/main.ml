
open Cmpmodel

open Core_extended
open Core.Std (* For In_channel *)

(* Manual creation of a model*)
let manual_model : d_model = (
  ("MData", [
      Alias("myInt", Prim INT32);
      Struct("myStruct", [
          "f1_aliased",   TypeRef "myInt";
          "f2_unaliased", Prim INT32
        ])
    ])
, ("MContracts", [
    "MyInterface", [
      "m1", Prim VOID, [];
      "m2", TypeRef "myInt", ["param1", IN, TypeRef "myStruct"]
    ]
  ])
, ("MComponents", [
    "Cmp1", [], [];
    "Cmp2", [], []
  ])
, ("MDeployment", (
    [
      CmpRef "Cmp1"; CmpRef "Cmp2"
    ],
    [
      (CmpRef "Cmp1", PortRef "pOut"), (CmpRef "Cmp2", PortRef "pIn")
    ]))
);;

(* Parsing of a file*)
let parse filename =
  let try_parsing lbuf =
    try Cmpmodel_parser.model_root Cmpmodel_lexer.tokenize lbuf with
    | Cmpmodel_lexer.LexError msg -> failwith ("Lexer error: " ^ msg)
  in
  let inx = In_channel.create filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  let parsed = try_parsing lexbuf in
  In_channel.close inx;
  match parsed with
  | Some m -> m
  | None -> failwith "An error occurred"
;;


let print_model model =
  print_endline (Extended_sexp.to_string_hum' (sexp_of_d_model model))
;;


let _ =
  print_endline "--Serializing an example";
  print_model manual_model;
  print_endline "Done";
  print_newline ();
  print_endline "--Parsing an example file";
  let parsed_model = parse "example/dummy.model" in
  (
    print_endline "Result of parsing:";
    print_model parsed_model
  );
  print_endline "Done"
