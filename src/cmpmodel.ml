(* A dummy DSL definition *)
(* Model definitions are prefixed with d_ *)

open Sexplib
open Sexplib.Conv

(*
 TODO Test other modeling options such as
   - Using records (and possibly an extension for fields access)
   - Using objects for further extensibility
   - Using modules for further extensibility
*)

type d_id = string
[@@deriving sexp]

type d_dataModule = d_id * d_dataType list
and  d_dataType   = Prim   of d_primitive
                  | Alias  of d_alias
                  | Struct of d_structure
                  | TypeRef of d_id
and  d_primitive  = VOID | INT32 | FLOAT32 | CHAR | BOOL
and  d_alias      = d_id * d_dataType
and  d_field      = d_id * d_dataType
and  d_sequence   = d_id * d_dataType
and  d_structure  = d_id * d_field list
[@@deriving sexp]

type d_contractModule = d_id * d_interface list
and  d_interface = d_id * d_method list
and  d_method    = d_id * d_dataType * d_param list
and  d_param     = d_id * d_direction * d_dataType
and  d_direction = IN | OUT | INOUT
[@@deriving sexp]

type d_componentModule = d_id * d_component list
and  d_component = d_id * d_port list * d_attribute list
and  d_port      = d_id * d_port_contract
and  d_port_contract = OFFERED of d_interface | REQUIRED of d_interface
and  d_attribute = d_id * d_dataType
[@@deriving sexp]

type d_deploymentModule = d_id * d_deployment
and  d_deployment = d_component_ref list * d_connection list
and  d_connection = (d_component_ref * d_port_ref) *  (d_component_ref * d_port_ref)
and  d_component_ref = CmpRef of d_id
and  d_port_ref = PortRef of d_id
[@@deriving sexp]

type d_model = d_dataModule * d_contractModule * d_componentModule * d_deploymentModule
[@@deriving sexp]
