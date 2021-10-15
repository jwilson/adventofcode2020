{:ok, contents} = File.read("day1input.txt")
input = contents \
  |> String.split("\n", trim: true) \
  |> Enum.map(&String.to_integer/1)


defmodule Advent1a do
  def attempt_one([head | tail]) do
    compared_value = Enum.reduce_while(tail, 0, fn x, _ ->
      if x + head == 2020, do: {:halt, -x}, else: {:cont, x}
    end)
    if compared_value > 0, do: Advent1.calc(tail), else: head * -compared_value
  end

  def attempt_two(input) do
    input
      |> Enum.map(&(2020 - &1))
      |> MapSet.new()
      |> MapSet.intersection(MapSet.new(input))
      |> Enum.product()
  end
end

Advent1a.attempt_one(input)
Advent1a.attempt_two(input)
