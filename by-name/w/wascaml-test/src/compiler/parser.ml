open Ast
open Tokens
open Result

let rec parse tokens =
  match parse_expr tokens with
  | ast, [] | ast, [ EOF ] -> ast
  | ast, rest -> (
      match ast with
      | Ok ast ->
          Printf.printf "Failed to parse: %s\n" (string_of_tokens rest);
          Printf.printf "Ast: %s\n" (string_of_ast ast);
          error "Failed to parse"
      | Error err ->
          Printf.printf "%s\n" err;
          error err)

and parse_expr tokens =
  match parse_let_expr tokens with
  | Ok ast, rest -> (ok ast, rest)
  | _ -> (
      match parse_if_expr tokens with
      | Ok ast, rest -> (ok ast, rest)
      | _ -> (
          match parse_fun_expr tokens with
          | Ok ast, rest -> (ok ast, rest)
          | _ -> (
              match parse_match_expr tokens with
              | Ok ast, rest -> (ok ast, rest)
              | _ -> (
                  match parse_equal_expr tokens with
                  | Ok ast, rest -> (ok ast, rest)
                  | _, rest -> (error "Failed to parse expr", rest)))))

and parse_let_expr tokens =
  match tokens with
  | Let :: Identifier ident :: Equal :: rest -> (
      match parse_expr rest with
      | Ok expr1, rest -> (
          match rest with
          | In :: rest -> (
              match parse_expr rest with
              | Ok expr2, rest -> (ok (Ast.Let (ident, expr1, expr2)), rest)
              | _, rest -> (error "Expected expr", rest))
          | rest -> (error "Expected `in` keyword", rest))
      | _, rest -> (error "Expected expr", rest))
  | rest -> (error "Failed to parse in `parse_let_expr`", rest)

and parse_if_expr tokens =
  match tokens with
  | If :: rest -> (
      match parse_expr rest with
      | Ok cond, Then :: rest -> (
          match parse_expr rest with
          | Ok then_, Else :: rest -> (
              match parse_expr rest with
              | Ok else_, rest -> (ok (Ast.If (cond, then_, else_)), rest)
              | _, rest -> (error "Expected expr", rest))
          | _, rest -> (error "Expected `else` keyword", rest))
      | _, rest -> (error "Expected `then` keyword", rest))
  | rest -> (error "Expected `if` keyword", rest)

and parse_fun_expr tokens =
  match tokens with
  | Function :: Identifier ident :: Arrow :: rest -> (
      match parse_expr rest with
      | Ok expr, rest -> (ok (Fun (ident, expr)), rest)
      | _, rest -> (error "Expected expr after `->`", rest))
  | rest -> (error "Failed to parse in `parse_fun_expr`", rest)

and parse_match_expr tokens =
  match tokens with
  | Match :: rest -> (
      match parse_expr rest with
      | Ok expr, With :: rest -> (
          match parse_match_case_list rest with
          | Ok cases, rest -> (ok (Ast.Match (expr, cases)), rest)
          | _, rest -> (error "Expected match cases", rest))
      | _, rest -> (error "Expected `with` keyword", rest))
  | rest -> (error "Expected `match` keyword", rest)

and parse_match_case_list tokens =
  match parse_match_case tokens with
  | Ok case, rest -> (
      match rest with
      | VerticalBar :: rest -> (
          match parse_match_case_list rest with
          | Ok cases, rest -> (ok (case :: cases), rest)
          | _, rest -> (error "Failed to parse match cases", rest))
      | _ -> (ok [ case ], rest))
  | _, rest -> (error "Failed to parse match case list", rest)

and parse_match_case tokens =
  match parse_expr tokens with
  | Ok expr1, Arrow :: rest -> (
      match parse_expr rest with
      | Ok expr2, rest -> (ok (expr1, expr2), rest)
      | _, rest -> (error "Expected expr after `->`", rest))
  | _, rest -> (error "Failed to parse match case", rest)

and parse_equal_expr tokens =
  match parse_add_sub_expr tokens with
  | Ok left, rest -> (
      match rest with
      | Equal :: rest -> (
          match parse_equal_expr rest with
          | Ok right, rest -> (ok (Eq (left, right)), rest)
          | _ -> (ok left, rest))
      | NotEqual :: rest -> (
          match parse_equal_expr rest with
          | Ok right, rest -> (ok (Neq (left, right)), rest)
          | _ -> (ok left, rest))
      | _ -> (ok left, rest))
  | _, rest -> (error "Failed to parse in `parse_equal_expr`", rest)

and parse_add_sub_expr tokens =
  match parse_mul_div_expr tokens with
  | Ok left, rest -> (
      match rest with
      | Plus :: rest -> (
          match parse_add_sub_expr rest with
          | Ok right, rest -> (ok (Ast.Plus (left, right)), rest)
          | _ -> (ok left, rest))
      | Hyphen :: rest -> (
          match parse_add_sub_expr rest with
          | Ok right, rest -> (ok (Minus (left, right)), rest)
          | _ -> (ok left, rest))
      | _ -> (ok left, rest))
  | _, rest -> (error "Failed to parse in `parse_add_sub_expr`", rest)

and parse_mul_div_expr tokens =
  match parse_primary_expr tokens with
  | Ok left, rest -> (
      match rest with
      | Asterisk :: rest -> (
          match parse_mul_div_expr rest with
          | Ok right, rest -> (ok (Times (left, right)), rest)
          | _ -> (ok left, rest))
      | Slash :: rest -> (
          match parse_mul_div_expr rest with
          | Ok right, rest -> (ok (Div (left, right)), rest)
          | _ -> (ok left, rest))
      | _ -> (ok left, rest))
  | _, rest -> (error "Failed to parse in `parse_mul_div_expr`", rest)

and parse_primary_expr tokens =
  match tokens with
  | Int n :: rest -> (ok (IntLit n), rest)
  | Float f :: rest -> (ok (FloatLit f), rest)
  | String s :: rest -> (ok (StringLit s), rest)
  | Bool b :: rest -> (ok (BoolLit b), rest)
  | Identifier id :: rest -> (
      match rest with
      | LeftParen :: rest -> (
          match parse_expr rest with
          | Ok expr1, rest -> (
              match rest with
              | Comma :: rest -> (
                  match parse_expr rest with
                  | Ok expr2, RightParen :: rest ->
                      (ok (App (expr1, expr2)), rest)
                  | _, rest ->
                      ( error
                          "Expected second expression and closing parenthesis",
                        rest ))
              | RightParen :: rest -> (ok (App (Ident id, expr1)), rest)
              | rest -> (error "Expected closing parenthesis", rest))
          | _, rest -> (error "Expected expression after `(`", rest))
      | _ -> (ok (Ident id), rest))
  | LeftParen :: rest -> (
      match parse_expr rest with
      | Ok expr, RightParen :: rest -> (ok expr, rest)
      | _, rest -> (error "Expected closing parenthesis", rest))
  | rest -> (error "Failed to parse in `parse_primary_expr`", rest)

and parse_expr_list tokens =
  match parse_expr tokens with
  | Ok expr, rest -> (
      match rest with
      | Comma :: rest -> (
          match parse_expr_list rest with
          | Ok expr_list, rest -> (ok (expr :: expr_list), rest)
          | _, rest -> (error "Failed to parse expression list", rest))
      | _ -> (ok [ expr ], rest))
  | _, rest -> (error "Failed to parse in `parse_expr_list`", rest)
