open Compiler.Tokenizer
open Compiler.Tokens

let token_testable =
  Alcotest.testable
    (Fmt.of_to_string (fun t ->
         match t with
         | EOF -> "EOF"
         | Identifier i -> "Identifier(" ^ i ^ ")"
         | Int n -> "Int(" ^ string_of_int n ^ ")"
         | Float f -> "Float(" ^ string_of_float f ^ ")"
         | String s -> "String(" ^ s ^ ")"
         | Bool b -> "Bool(" ^ string_of_bool b ^ ")"
         | Plus -> "Plus"
         | Hyphen -> "Hyphen"
         | Asterisk -> "Asterisk"
         | Slash -> "Slash"
         | Equal -> "Equal"
         | Less -> "Less"
         | Greater -> "Greater"
         | NotEqual -> "NotEqual"
         | Arrow -> "Arrow"
         | SemiColon -> "SemiColon"
         | DoubleColon -> "DoubleColon"
         | Colon -> "Colon"
         | Dot -> "Dot"
         | Comma -> "Comma"
         | LeftParen -> "LeftParen"
         | RightParen -> "RightParen"
         | LeftBracket -> "LeftBracket"
         | RightBracket -> "RightBracket"
         | VerticalBar -> "VerticalBar"
         | Function -> "Function"
         | Recursive -> "Recursive"
         | Let -> "Let"
         | In -> "In"
         | If -> "If"
         | Then -> "Then"
         | Else -> "Else"
         | Match -> "Match"
         | With -> "With"
         | Invalid -> "Invalid"))
    equal_token

let test_tokenize_four_arithmetic_ops _ =
  let input = "a + b * 42 - (c / 3)" in
  let tokens = tokenize input in
  let expect =
    [
      Identifier "a";
      Plus;
      Identifier "b";
      Asterisk;
      Int 42;
      Hyphen;
      LeftParen;
      Identifier "c";
      Slash;
      Int 3;
      RightParen;
      EOF;
    ]
  in
  Alcotest.(check (list token_testable)) "same tokens" tokens expect

let () =
  Alcotest.run "Wascaml.Compiler.tokenizer"
    [
      ( "tokenizer",
        [
          Alcotest.test_case "four_arithmetic_ops" `Quick
            test_tokenize_four_arithmetic_ops;
        ] );
    ]
