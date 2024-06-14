open Compiler.Tokenizer
open Compiler.Tokens

let test_tokenize _ =
  let input = "a + b * 42 - (c / 3)" in
  let _ = tokenize input in
  let _ = [
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
  ] in
  Alcotest.fail "test"

let () =
  Alcotest.run "Wascaml.Compiler.tokenizer" [
    ("tokenizer", [Alcotest.test_case "test_tokenize" `Quick test_tokenize; ])
  ]

