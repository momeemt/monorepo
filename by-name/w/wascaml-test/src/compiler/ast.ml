type ast =
  | IntLit of int
  | FloatLit of float
  | StringLit of string
  | BoolLit of bool
  | Ident of string
  | If of ast * ast * ast
  | Let of string * ast * ast
  | LetRec of string * string * ast * ast
  | Fun of string * ast
  | App of ast * ast
  | Eq of ast * ast
  | Neq of ast * ast
  | Greater of ast * ast
  | Less of ast * ast
  | Plus of ast * ast
  | Minus of ast * ast
  | Times of ast * ast
  | Div of ast * ast
  | Empty
  | Match of ast * (ast * ast) list
  | Var of string

type value =
  | IntVal of int
  | FloatVal of float
  | StringVal of string
  | BoolVal of bool
  | ListVal of value list
  | Funval of string * ast * env
  | RecFunVal of string * string * ast * env

and env = (string, value) Hashtbl.t

let rec string_of_value v =
  match v with
  | IntVal i -> string_of_int i
  | FloatVal f -> string_of_float f
  | StringVal s -> s
  | BoolVal b -> string_of_bool b
  | ListVal l -> "[" ^ String.concat ", " (List.map string_of_value l) ^ "]"
  | Funval _ -> "<fun>"
  | RecFunVal _ -> "<fun>"

let rec string_of_ast e =
  match e with
  | IntLit i -> string_of_int i
  | FloatLit f -> string_of_float f
  | StringLit s -> "\"" ^ s ^ "\""
  | BoolLit b -> string_of_bool b
  | Ident id -> id
  | If (e1, e2, e3) ->
      "if " ^ string_of_ast e1 ^ " then " ^ string_of_ast e2 ^ " else "
      ^ string_of_ast e3
  | Let (id, e1, e2) ->
      "let " ^ id ^ " = " ^ string_of_ast e1 ^ " in " ^ string_of_ast e2
  | LetRec (id1, id2, e1, e2) ->
      "let rec " ^ id1 ^ " " ^ id2 ^ " = " ^ string_of_ast e1 ^ " in "
      ^ string_of_ast e2
  | Fun (id, e) -> "fun " ^ id ^ " -> " ^ string_of_ast e
  | App (e1, e2) -> string_of_ast e1 ^ " " ^ string_of_ast e2
  | Eq (e1, e2) -> string_of_ast e1 ^ " = " ^ string_of_ast e2
  | Neq (e1, e2) -> string_of_ast e1 ^ " <> " ^ string_of_ast e2
  | Greater (e1, e2) -> string_of_ast e1 ^ " > " ^ string_of_ast e2
  | Less (e1, e2) -> string_of_ast e1 ^ " < " ^ string_of_ast e2
  | Plus (e1, e2) -> string_of_ast e1 ^ " + " ^ string_of_ast e2
  | Minus (e1, e2) -> string_of_ast e1 ^ " - " ^ string_of_ast e2
  | Times (e1, e2) -> string_of_ast e1 ^ " * " ^ string_of_ast e2
  | Div (e1, e2) -> string_of_ast e1 ^ " / " ^ string_of_ast e2
  | Empty -> "[]"
  | Match (e, l) ->
      "match " ^ string_of_ast e ^ " with "
      ^ String.concat " | "
          (List.map
             (fun (p, e) -> string_of_ast p ^ " -> " ^ string_of_ast e)
             l)
  | Var id -> id
