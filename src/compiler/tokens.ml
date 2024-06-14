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
  | True  (** The `true` keyword *)
  | False  (** The `false` keyword *)
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
  | True, True -> true
  | False, False -> true
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
