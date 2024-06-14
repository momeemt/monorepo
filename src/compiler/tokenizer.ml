open Tokens

let tokenize _ (* input *) =
  let aux _ (* pos *) tokens = List.rev (EOF :: tokens) in
  aux 0 []
