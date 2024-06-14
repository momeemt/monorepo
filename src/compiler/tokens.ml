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
  | DoubleColon  (** The '::' operator *)
  | LeftParen  (** The '(' operator *)
  | RightParen  (** The ')' operator *)
  | LeftBracket  (** The '[' operator *)
  | RightBracket  (** The ']' operator *)
  | Arrow  (** The '->' operator *)
  | VerticalBar  (** The '|' operator *)
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
