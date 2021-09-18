{:ok, contents} = File.read("day1input.txt")
split_contents = contents \
  |> String.split("\n", trim: true) \
  |> Enum.map(&String.to_integer/1)

defmodule Advent1 do
  def calc([head | tail]) do
    compared_value = Enum.reduce_while(tail, 0, fn x, _ ->
      if x + head == 2020, do: {:halt, x * -1}, else: {:cont, x}
    end)
    if compared_value > 0, do: Advent1.calc(tail), else: head * compared_value * -1
  end
end

Advent1.calc(split_contents)
