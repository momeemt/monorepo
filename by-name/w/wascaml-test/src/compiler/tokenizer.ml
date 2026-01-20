open Tokens

let tokenize input =
  let length = String.length input in
  let keywords =
    [
      ("true", Bool true);
      ("false", Bool false);
      ("fun", Function);
      ("rec", Recursive);
      ("let", Let);
      ("in", In);
      ("if", If);
      ("then", Then);
      ("else", Else);
      ("match", Match);
      ("with", With);
    ]
  in
  let rec tokenize_number pos tokens =
    let start_pos = pos in
    let rec find_end pos =
      if
        pos < length
        && ((input.[pos] >= '0' && input.[pos] <= '9') || input.[pos] == '.')
      then find_end (pos + 1)
      else pos
    in
    let end_pos = find_end pos in
    let number_str = String.sub input start_pos (end_pos - start_pos) in
    let number =
      if String.contains number_str '.' then Float (float_of_string number_str)
      else Int (int_of_string number_str)
    in
    aux end_pos (number :: tokens)
  and tokenize_identifier pos tokens =
    let start_pos = pos in
    let rec find_end pos =
      if
        pos < length
        && ((input.[pos] >= 'a' && input.[pos] <= 'z')
           || (input.[pos] >= 'A' && input.[pos] <= 'Z'))
      then find_end (pos + 1)
      else pos
    in
    let end_pos = find_end pos in
    let ident = String.sub input start_pos (end_pos - start_pos) in
    let token =
      match List.assoc_opt ident keywords with
      | Some kw -> kw
      | None -> Identifier ident
    in
    aux end_pos (token :: tokens)
  and tokenize_string pos tokens =
    let start_pos = pos in
    let rec find_end pos =
      if pos < length && input.[pos] <> '"' then find_end (pos + 1) else pos
    in
    let end_pos = find_end pos in
    if end_pos < length && input.[end_pos] = '"' then
      let str = String.sub input start_pos (end_pos - start_pos) in
      aux (end_pos + 1) (String str :: tokens)
    else aux end_pos (Invalid :: tokens)
  and aux pos tokens =
    if pos >= length then List.rev (EOF :: tokens)
    else
      match input.[pos] with
      | ' ' | '\t' | '\n' -> aux (pos + 1) tokens
      | '0' .. '9' -> tokenize_number pos tokens
      | 'a' .. 'z' | 'A' .. 'Z' -> tokenize_identifier pos tokens
      | '"' -> tokenize_string pos tokens
      | '+' -> aux (pos + 1) (Plus :: tokens)
      | '-' ->
          if pos + 1 < length && input.[pos + 1] = '>' then
            aux (pos + 2) (Arrow :: tokens)
          else aux (pos + 1) (Hyphen :: tokens)
      | '*' -> aux (pos + 1) (Asterisk :: tokens)
      | '/' -> aux (pos + 1) (Slash :: tokens)
      | '=' -> aux (pos + 1) (Equal :: tokens)
      | '<' ->
          if pos + 1 < length && input.[pos + 1] = '>' then
            aux (pos + 2) (NotEqual :: tokens)
          else aux (pos + 1) (Less :: tokens)
      | '>' -> aux (pos + 1) (Greater :: tokens)
      | ';' -> aux (pos + 1) (SemiColon :: tokens)
      | ':' ->
          if pos + 1 < length && input.[pos + 1] = ':' then
            aux (pos + 2) (DoubleColon :: tokens)
          else aux (pos + 1) (Colon :: tokens)
      | '(' -> aux (pos + 1) (LeftParen :: tokens)
      | ')' -> aux (pos + 1) (RightParen :: tokens)
      | '[' -> aux (pos + 1) (LeftBracket :: tokens)
      | ']' -> aux (pos + 1) (RightBracket :: tokens)
      | '|' -> aux (pos + 1) (VerticalBar :: tokens)
      | '.' -> aux (pos + 1) (Dot :: tokens)
      | ',' -> aux (pos + 1) (Comma :: tokens)
      | _ -> List.rev (EOF :: tokens)
  in
  aux 0 []
