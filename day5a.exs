{:ok, contents} = File.read("day5input.txt")
input = contents \
  |> String.split("\n")

defmodule Advent5a do
  def go(input) do
    process_data_line(%{rows: []}, input)
    |> sort_data()
    |> elem(2)
  end

  defp process_data_line(state, []), do: state
  defp process_data_line(state, [head | tail]) do
    {row, col} = String.split_at(head, -3)
    {int_row, _} = String.replace(row, "F", "0") |> String.replace("B", "1") |> Integer.parse(2)
    {int_col, _} = String.replace(col, "R", "1") |> String.replace("L", "0")|> Integer.parse(2)
    process_data_line(%{state | rows: [{int_row, int_col, int_row * 8 + int_col} | state.rows]}, tail)
  end

  defp sort_data(state) do
    Enum.reduce(state.rows, {0, 0, 0}, &(if elem(&1, 2) > elem(&2, 2), do: &1, else: &2))
  end
end

Advent5a.go(input)
