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
