type type_ = I32 | I64 | F32 | F64

type value =
  | Int32 of int32
  | Int64 of int64
  | Float32 of float
  | Float64 of float

type instr =
  | Const of type_ * value
  | Add of type_
  | Sub of type_
  | Mul of type_
  | DivS of type_
  | Load of type_
  | Store of type_
  | Call of string

type expr = Instr of instr | Block of expr list

type func = {
  name : string;
  params : (string * type_) list;
  results : type_ list;
  body : expr list;
}

type import_desc = FuncImport of (type_ list * type_ list)
type import = { module_name : string; name : string; desc : import_desc }
type module_ = { imports : import list; funcs : func list }

let string_of_type vt =
  match vt with I32 -> "i32" | I64 -> "i64" | F32 -> "f32" | F64 -> "f64"

let string_of_value value =
  match value with
  | Int32 n -> Int32.to_string n
  | Int64 n -> Int64.to_string n
  | Float32 f -> Printf.sprintf "%f" f
  | Float64 f -> Printf.sprintf "%f" f

let string_of_instr instr =
  match instr with
  | Const (t, v) ->
      Printf.sprintf "%s.const %s" (string_of_type t) (string_of_value v)
  | Add t -> Printf.sprintf "%s.add" (string_of_type t)
  | Sub t -> Printf.sprintf "%s.sub" (string_of_type t)
  | Mul t -> Printf.sprintf "%s.mul" (string_of_type t)
  | DivS t -> Printf.sprintf "%s.div_s" (string_of_type t)
  | Load t -> Printf.sprintf "%s.load" (string_of_type t)
  | Store t -> Printf.sprintf "%s.store" (string_of_type t)
  | Call name -> Printf.sprintf "call $%s" name

let rec string_of_expr expr =
  match expr with
  | Instr instr -> string_of_instr instr
  | Block exprs ->
      Printf.sprintf "(block\n %s\n)"
        (List.map string_of_expr exprs |> String.concat "\n  ")

let string_of_func func =
  let params_str =
    List.map
      (fun (name, typ) ->
        Printf.sprintf "(param %s %s)" name (string_of_type typ))
      func.params
    |> String.concat " "
  in
  let results_str =
    List.map string_of_type func.results |> String.concat " " |> fun s ->
    if s = "" then "" else Printf.sprintf "(result %s)" s
  in
  let body_str = List.map string_of_expr func.body |> String.concat "\n  " in
  Printf.sprintf "(func $%s %s %s\n  %s\n)" func.name params_str results_str
    body_str

let string_of_import_desc import_desc =
  match import_desc with
  | FuncImport (params, results) ->
      let params_str = List.map string_of_type params |> String.concat " " in
      let results_str = List.map string_of_type results |> String.concat " " in
      Printf.sprintf "(func (param %s) (result %s))" params_str results_str

let string_of_import import =
  Printf.sprintf "(import \"%s\" \"%s\" %s)" import.module_name import.name
    (string_of_import_desc import.desc)

let string_of_module module_ =
  let imports_str =
    List.map string_of_import module_.imports |> String.concat "\n"
  in
  let funcs_str =
    List.map string_of_func module_.funcs |> String.concat "\n\n"
  in
  Printf.sprintf "(module\n%s\n%s\n)" imports_str funcs_str
