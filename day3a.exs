{:ok, contents} = File.read("day3input.txt")
input = contents \
  |> String.split("\n", trim: true)

defmodule Advent3 do
  @right 3
  @down 1
  @line_count 31
  # @line_count 11

  def go(input) do
    process_line(increment(%{x: 0, y: 0}), input)
  end

  defp increment(state) do
    %{state | x: state.x + @right, y: state.y + @down}
  end

  defp process_line(state, input) when state.y > length(input), do: state
  defp process_line(state, input) when state.x >= @line_count, do: process_line(%{state | x: state.x - @line_count}, input)
  defp process_line(state, input) do
    is_tree?(state, input)
    |> increment()
    |> process_line(input)
  end

  defp is_tree?(state, input) do
    case get_grid_value(state, input) do
      {:ok, "#"} -> increment_tree_count(state)
      _ -> state
    end
  end

  defp get_grid_value(state, input) do
    case Enum.fetch(input, state.y) do
      {:ok, element} -> Enum.fetch(String.graphemes(element), state.x)
      :error -> ""
    end
  end

  defp increment_tree_count(state) do
    if (Map.has_key?(state, :t)) do
      %{state | t: state.t + 1}
    else
      Map.put_new(state, :t, 1)
    end
  end
end

Advent3.go(input)
