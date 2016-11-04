%token <Cmpmodel.d_id> ID

%token MODULE_DATA
%token ALIAS

%token MODULE_CONTRACTS
%token MODULE_COMP
%token MODULE_DEPL
%token LBRACE
%token RBRACE
%token EOF

%start <Cmpmodel.d_model option> model_root

%%

model_root:
  | md = mod_data; mc = mod_contracts; mcomp = mod_components; mdepl = mod_deployment
    {
      Some { Cmpmodel.empty
        with  data = md;
              contracts = mc;
              components = mcomp;
      }
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
  | MODULE_DATA; LBRACE; dc = data_content; RBRACE { dc : Cmpmodel.d_dataModule }
  ;
data_content:
  | { [] }
  | ds = data_content; d = datatype { d::ds }
  ;
datatype:
  | ALIAS; id = ID; { Cmpmodel.Alias (id, Cmpmodel.Prim INT32) }
  ;

mod_contracts:
  | MODULE_CONTRACTS; LBRACE; RBRACE { ([]) : Cmpmodel.d_contractModule }
  ;

mod_components:
  | MODULE_COMP; LBRACE; RBRACE { ([]) : Cmpmodel.d_componentModule }
  ;

mod_deployment:
  | MODULE_DEPL; LBRACE; RBRACE { ([], []) : Cmpmodel.d_deploymentModule }
  ;
