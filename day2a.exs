{:ok, contents} = File.read("day2input.txt")
input = contents \
  |> String.split("\n", trim: true) \
  |> Enum.map(&String.split/1)


defmodule Advent2 do
  def go(input) do
    process(input, 0)
  end

  def get_min_max(value) do
    [min, max] = String.split(value, "-")
    [String.to_integer(min), String.to_integer(max)]
  end

  def get_char(value) do
    String.replace(value, ":", "")
  end

  def get_password(value) do
    String.to_charlist(value)
  end

  defp process([head | tail], valid_count) do
    head_tuple = List.to_tuple(head)

    [min, max] = get_min_max(elem(head_tuple, 0))

    char = get_char(elem(head_tuple, 1))
    password = get_password(elem(head_tuple, 2))
    count = count_letters(password, %{})

    char_value = Map.get(count, String.to_charlist(char) |> hd)

    if (char_value >= min && char_value <= max) do
      process(tail, valid_count + 1)
    else
      process(tail, valid_count)
    end
  end

  defp process([], valid_count) do
    valid_count
  end

  defp count_letters([head | tail], count) do
    count = Map.update(count, head, 1, &(&1 + 1))
    count_letters(tail, count)
  end

  defp count_letters([], count) do
    count
  end
end

Advent2.go(input)
