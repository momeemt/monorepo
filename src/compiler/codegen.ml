open Ast
open Runtime.Wat

exception CodegenError of string

let rec codegen_expr expr =
  match expr with
  | IntLit n -> Instr (Const (I32, Int32 (Int32.of_int n)))
  | Plus (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Add I32) ]
  | Minus (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Sub I32) ]
  | Times (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Mul I32) ]
  | Div (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (DivS I32) ]
  | _ -> raise (CodegenError "Unsupported expression")

let codegen ast =
  let start_func =
    {
      name = "_start";
      params = [];
      results = [];
      body = [ codegen_expr ast; Instr (Call "proc_exit") ];
    }
  in
  let module_ =
    {
      imports =
        [
          {
            module_name = "wasi_snapshot_preview1";
            name = "proc_exit";
            desc = FuncImport ("proc_exit", [ I32 ], []);
          };
        ];
      exports = [ { name = "_start"; desc = FuncExport "_start" } ];
      funcs = [ start_func ];
      memory = Some { min_pages = 1; max_pages = None };
    }
  in
  string_of_module module_
