open Ast
open Runtime.Wat

exception CodegenError of string

let current_offset = ref 0
let data_segments = ref []
let funcs = ref []

let rec codegen_expr expr =
  match expr with
  | IntLit n -> Instr (Const (I32, Int32 (Int32.of_int n)))
  | FloatLit f -> Instr (Const (F32, Float32 f))
  | StringLit s ->
      let offset = !current_offset in
      current_offset := offset + String.length s;
      data_segments := (offset, s) :: !data_segments;
      Instr (Const (I32, Int32 (Int32.of_int offset)))
  | BoolLit b -> Instr (Const (I32, Int32 (if b then 1l else 0l)))
  | Ident id -> Instr (GetLocal id)
  | If (cond, then_expr, else_expr) ->
      Block
        [
          codegen_expr cond;
          Instr
            (If ([], [ codegen_expr then_expr ], [ codegen_expr else_expr ]));
        ]
  | Let (id, value_expr, body_expr) ->
      Block
        [ codegen_expr value_expr; Instr (SetLocal id); codegen_expr body_expr ]
  | LetRec (id, param, body_expr, in_expr) ->
      let func =
        {
          name = id;
          params = [ (param, I32) ];
          (* Defined as temp type I32 *)
          results = [];
          body = [ codegen_expr body_expr ];
        }
      in
      funcs := func :: !funcs;
      codegen_expr in_expr
  | Fun (name, body) ->
      let func =
        { name; params = []; results = []; body = [ codegen_expr body ] }
      in
      funcs := func :: !funcs;
      Instr Drop
  | App (fn, arg) ->
      Block
        [
          codegen_expr arg;
          (match fn with
          | Ident id -> Instr (Call id)
          | _ ->
              raise
                (CodegenError "Function applications must use function names"));
        ]
  | Eq (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Eq I32) ]
  | Neq (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Ne I32) ]
  | Greater (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (GtS I32) ]
  | Less (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (LtS I32) ]
  | Plus (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Add I32) ]
  | Minus (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Sub I32) ]
  | Times (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (Mul I32) ]
  | Div (a, b) -> Block [ codegen_expr a; codegen_expr b; Instr (DivS I32) ]
  | Empty -> Instr Drop
  | Match (expr, cases) ->
      Block
        (codegen_expr expr
        :: List.map
             (fun (pattern, result) ->
               Block
                 [
                   codegen_expr pattern;
                   Instr (If ([], [ codegen_expr result ], []));
                 ])
             cases)
  | Var id -> Instr (GetLocal id)

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
      funcs = start_func :: !funcs;
      memory = Some { min_pages = 1; max_pages = None };
      data = !data_segments;
    }
  in
  string_of_module module_
