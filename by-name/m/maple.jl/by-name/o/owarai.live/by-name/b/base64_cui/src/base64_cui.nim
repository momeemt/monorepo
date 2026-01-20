import base64, re, strutils, parseopt2

type base64_condition = enum
  none
  encode
  decode
  debug_encode
  debug_decode
  tweet
  wait_encode_count

when isMainModule:
  var condition: base64_condition = none
  var stock_str: string = ""
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      if condition == none:
        echo "[Error] There must be an argument! See 'b64dec -h' ."
      elif condition == decode:
        var user_input: string = key
        while user_input.match(re"^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$"):
          user_input = decode(user_input)
          user_input = user_input.replace(" ","")
          user_input = user_input.replace("\n","")
        echo "---------------------------------"
        echo "decode: ", user_input
      elif condition == encode:
        stock_str = key
        condition = wait_encode_count
      elif condition == wait_encode_count:
        for i in 1..key.parseInt:
          stock_str = encode(stock_str)
        echo "---------------------------------"
        echo "encode: ", stock_str
        stock_str = ""
        condition = none
      elif condition == tweet:
        var user_input: string = key
        while user_input.len <= 280:
          user_input = encode(user_input)
        echo "---------------------------------"
        echo "encode for twitter: ", decode(user_input) 
    of cmdLongOption, cmdShortOption:
      if key == "encode" or key == "e":
        condition = encode
      elif key == "decode" or key == "d":
        condition = decode
      elif key == "debug_encode" or key == "de":
        condition = debug_encode
      elif key == "debug_decode" or key == "debug_decode":
        condition = debug_decode
      elif key == "help" or key == "h":
        echo "[encode] base64_cui -e [string] [count]"
        echo "[encode for twitter] base64_cui -t [string]"
        echo "[decode] base64_cui -d [string]"
      elif key == "tweet" or key == "t":
        condition = tweet
    of cmdEnd:
      discard
  if condition == wait_encode_count:
    echo "---------------------------------"
    echo "encode: ", encode(stock_str)