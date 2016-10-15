%token <string> ID
%token MODULE_DATA
%token MODULE_CONTRACTS
%token MODULE_COMP
%token MODULE_DEPL
%token LBRACE
%token RBRACE
%token EOF

%start <Cmpmodel.d_model option> model_root

%%

model_root:
  | m = module_definition
    { m }
  | EOF
    { None }
  ;

module_definition:
  | md = mod_data
    { Some ( md, ("none", []), ("none", []), ("none", ([], [])) ) }
  | mc = mod_contracts
    { Some ( ("none", []), mc, ("none", []), ("none", ([], [])) ) }
  ;

mod_data:
  | MODULE_DATA; id = ID; LBRACE; RBRACE { (id, []) : Cmpmodel.d_dataModule }
  ;

mod_contracts:
  | MODULE_CONTRACTS; id = ID; LBRACE; RBRACE { (id, []) : Cmpmodel.d_contractModule }
  ;
