{:ok, contents} = File.read("day1input.txt")
input = contents \
  |> String.split("\n", trim: true) \
  |> Enum.map(&String.to_integer/1)

defmodule Advent1b do
  def go(input) do
    paired = input |> Enum.map(fn x -> {x, 2020 - x} end)
    trips = for p <- paired, i <- input, do: [elem(p, 0), elem(p, 1), elem(p, 1) - i, i]
    amswer = Enum.filter(trips, fn [a, b, c, d] -> c in input end)
    |> Enum.map(fn [a, b, c, d] -> a * c * d end)
    |> MapSet.new()
    |> MapSet.to_list()
    |> List.first()
  end
end

Advent1b.go(input)
