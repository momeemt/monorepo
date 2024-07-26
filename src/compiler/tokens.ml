type token =
  | Plus  (** The '+' operator *)
  | Hyphen  (** The '-' operator *)
  | Asterisk  (** The '*' operator *)
  | Slash  (** The '/' operator *)
  | Equal  (** The '=' operator *)
  | Less  (** The '<' operator *)
  | Greater  (** The '>' operator *)
  | NotEqual  (** The '<>' operator *)
  | SemiColon  (** The ';' operator *)
  | Colon  (** The ':' operator *)
  | DoubleColon  (** The '::' operator *)
  | LeftParen  (** The '(' operator *)
  | RightParen  (** The ')' operator *)
  | LeftBracket  (** The '[' operator *)
  | RightBracket  (** The ']' operator *)
  | Arrow  (** The '->' operator *)
  | VerticalBar  (** The '|' operator *)
  | Dot  (** The '.' operator *)
  | Comma  (** The ',' operator *)
  | Function  (** The `fun` keyword *)
  | Recursive  (** The `rec` keyword *)
  | Let  (** The `let` keyword *)
  | In  (** The `in` keyword *)
  | If  (** The `if` keyword *)
  | Then  (** The `then` keyword *)
  | Else  (** The `else` keyword *)
  | Match  (** The `match` keyword *)
  | With  (** The `with` keyword *)
  | Int of int
  | Float of float
  | String of string
  | Bool of bool
  | Identifier of string
  | EOF
  | Invalid

let equal_token t1 t2 =
  match (t1, t2) with
  | EOF, EOF -> true
  | Identifier i1, Identifier i2 -> i1 = i2
  | Int n1, Int n2 -> n1 = n2
  | Float f1, Float f2 -> f1 = f2
  | String s1, String s2 -> s1 = s2
  | Bool b1, Bool b2 -> b1 = b2
  | Plus, Plus -> true
  | Hyphen, Hyphen -> true
  | Asterisk, Asterisk -> true
  | Slash, Slash -> true
  | Equal, Equal -> true
  | Less, Less -> true
  | Greater, Greater -> true
  | NotEqual, NotEqual -> true
  | Arrow, Arrow -> true
  | SemiColon, SemiColon -> true
  | DoubleColon, DoubleColon -> true
  | Colon, Colon -> true
  | Dot, Dot -> true
  | Comma, Comma -> true
  | LeftParen, LeftParen -> true
  | RightParen, RightParen -> true
  | LeftBracket, LeftBracket -> true
  | RightBracket, RightBracket -> true
  | VerticalBar, VerticalBar -> true
  | Function, Function -> true
  | Recursive, Recursive -> true
  | Let, Let -> true
  | In, In -> true
  | If, If -> true
  | Then, Then -> true
  | Else, Else -> true
  | Match, Match -> true
  | With, With -> true
  | Invalid, Invalid -> true
  | _ -> false

let string_of_token token =
  match token with
  | Plus -> "Plus"
  | Hyphen -> "Hyphen"
  | Asterisk -> "Asterisk"
  | Slash -> "Slash"
  | Equal -> "Equal"
  | Less -> "Less"
  | Greater -> "Greater"
  | NotEqual -> "NotEqual"
  | SemiColon -> "SemiColon"
  | Colon -> "Colon"
  | DoubleColon -> "DoubleColon"
  | LeftParen -> "LeftParen"
  | RightParen -> "RightParen"
  | LeftBracket -> "LeftBracket"
  | RightBracket -> "RightBracket"
  | Arrow -> "Arrow"
  | VerticalBar -> "VerticalBar"
  | Dot -> "Dot"
  | Comma -> "Comma"
  | Function -> "Function"
  | Recursive -> "Recursive"
  | Let -> "Let"
  | In -> "In"
  | If -> "If"
  | Then -> "Then"
  | Else -> "Else"
  | Match -> "Match"
  | With -> "With"
  | Int n -> "Int " ^ string_of_int n
  | Float f -> "Float " ^ string_of_float f
  | String s -> "String " ^ s
  | Bool b -> "Bool " ^ string_of_bool b
  | Identifier i -> "Identifier " ^ i
  | EOF -> "EOF"
  | Invalid -> "Invalid"

let string_of_tokens tokens =
  List.fold_left
    (fun acc token -> acc ^ string_of_token token ^ " ")
    ""
    tokens

