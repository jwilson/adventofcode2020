{:ok, contents} = File.read("day5input.txt")
input = contents \
  |> String.split("\n")

defmodule Advent5a do
  def go(input) do
    results = process_data_line(%{rows: [], mine: {0,0,0}}, input)
    |> sort_data()
    |> find_missing_seat()

    IO.puts(elem(results.mine, 2))
  end

  defp process_data_line(state, []), do: state
  defp process_data_line(state, [head | tail]) do
    {row, col} = String.split_at(head, -3)
    {int_row, _} = String.replace(row, "F", "0") |> String.replace("B", "1") |> Integer.parse(2)
    {int_col, _} = String.replace(col, "R", "1") |> String.replace("L", "0")|> Integer.parse(2)
    process_data_line(%{state | rows: [{int_row, int_col, int_row * 8 + int_col} | state.rows]}, tail)
  end

  defp sort_data(state) do
    %{state | rows: Enum.sort(state.rows, &(elem(&1, 2) < elem(&2, 2)))}
  end

  defp find_missing_seat(state, []), do: state
  defp find_missing_seat(state), do: find_missing_seat(state, state.rows)
  defp find_missing_seat(state, [head | tail]) do
    b = elem(hd(tail), 2)
    case b - 1 == elem(head, 2) && b + 1 == elem(hd(tl(tail)), 2) do
      false -> %{state | mine: {0, 0, b + 1}}
      true -> find_missing_seat(state, tail)
    end
  end
end

Advent5a.go(input)
