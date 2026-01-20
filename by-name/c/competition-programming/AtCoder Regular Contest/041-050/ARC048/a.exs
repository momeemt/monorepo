defmodule Main do
  def main do
    [a,b] =
      IO.read(:line)
      |> String.trim
      |> String.split(" ")
    a = String.to_integer(a)
    b = String.to_integer(b)
    if a < 0 && b > 0 do
      IO.puts(b-a+1)
    else
      IO.puts(b-a)
    end
  end
end