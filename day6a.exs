{:ok, contents} = File.read("day6input.txt")
input = contents \
  |> String.split("\n\n")

defmodule Advent6a do
  def go(input) do
    process_chunks(%{chunks: input, current_chunk: [], processed_chunks: []})
    |> total_answers()
  end

  defp process_chunks(state), do: process_chunks(state, state.chunks)
  defp process_chunks(state, []), do: state
  defp process_chunks(state, [head | tail]) do
    process_chunk(state, head)
    |> process_chunks(tail)
  end

  defp process_chunk(state, chunk) do
    process_chunk_lines(state, String.split(chunk, "\n"))
  end

  defp process_chunk_lines(state, []) do
    %{state | current_chunk: [], processed_chunks: [state.current_chunk | state.processed_chunks]}
  end
  defp process_chunk_lines(state, [head | tail]) do
    process_chunk_lines(%{state | current_chunk: String.graphemes(head) ++ state.current_chunk}, tail)
  end

  defp total_answers(state) do
    Enum.reduce(
      state.processed_chunks,
      0,
      &(&2 + length( MapSet.to_list( MapSet.new(&1) ) ) )
    )
  end
end

Advent6a.go(input)
