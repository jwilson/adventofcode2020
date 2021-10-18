{:ok, contents} = File.read("day4input.txt")
input = contents \
  |> String.split("\n")


defmodule Advent4a do
  def go(input) do
    process_data_line(%{current_chunk: [], chunks: [], current_passport: %{}, passports: [], valid_passports: 0}, input)
    |> process_chunk_data()
    |> validate_passports()
  end

  defp process_data_line(state, []), do: %{state | current_chunk: [], chunks: [state.current_chunk | state.chunks]}
  defp process_data_line(state, [head | tail]) do
    append_chunk(state, head)
    |> process_data_line(tail)
  end

  defp append_chunk(state, chunk_line) do
    case String.length(chunk_line) == 0 do
      false -> %{state | current_chunk: [chunk_line | state.current_chunk]}
      true -> %{state | current_chunk: [], chunks: [state.current_chunk | state.chunks]}
    end
  end

  defp process_chunk_data(state, []), do: state
  defp process_chunk_data(state), do: process_chunk_data(state, state.chunks)
  defp process_chunk_data(state, [head | tail]) do
    process_chunks(state, head)
    |> process_chunk_data(tail)
  end

  defp process_chunks(state, []), do: %{state | current_passport: %{}, passports: [state.current_passport | state.passports]}
  defp process_chunks(state, [head | tail]) do
    process_chunk_parts(state, String.split(head, " "))
    |> process_chunks(tail)
  end

  defp process_chunk_parts(state, []), do: state
  defp process_chunk_parts(state, [head | tail]) do
    new_state = case String.split(head, ":") do
      [key, value] -> %{state | current_passport: Map.put_new(state.current_passport, String.to_atom(key), value)}
      _ -> state
    end
    process_chunk_parts(new_state, tail)
  end

  defp validate_passports(state, []), do: state
  defp validate_passports(state), do: validate_passports(state, state.passports)
  defp validate_passports(state, [head | tail]) do
    new_state = case head do
      %{byr: _byr, iyr: _iyr, eyr: _eyr, hgt: _hgt, hcl: _hcl, ecl: _ecl, pid: _pid} -> %{state | valid_passports: state.valid_passports + 1}
      _ -> state
    end
    validate_passports(new_state, tail)
  end
end

Advent4a.go(input)
