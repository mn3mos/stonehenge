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
  | md = mod_data; mc = mod_contracts;
    {
      Some { Cmpmodel.empty with data = md; contracts = mc }
    }
  |
    {
      Some Cmpmodel.empty
    }
  | EOF
    {
      None
    }
  ;

mod_data:
  | MODULE_DATA; LBRACE; RBRACE { ([]) : Cmpmodel.d_dataModule }
  ;

mod_contracts:
  | MODULE_CONTRACTS; LBRACE; RBRACE { ([]) : Cmpmodel.d_contractModule }
  ;
