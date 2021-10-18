{:ok, contents} = File.read("day4input.txt")
input = contents \
  |> String.split("\n")


defmodule Advent4a do
  def go(input) do
    state = process_data_line(%{current_chunk: [], chunks: [], current_passport: %{}, passports: [], semi_valid_passports: [], valid_passports: []}, input)
    |> process_chunk_data()
    |> validate_passports_fields()
    |> validate_passports_values()
    IO.puts(length(state.valid_passports))
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

  defp process_chunk_data(state), do: process_chunk_data(state, state.chunks)
  defp process_chunk_data(state, []), do: state
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

  defp validate_passports_fields(state), do: validate_passports_fields(state, state.passports)
  defp validate_passports_fields(state, []), do: state
  defp validate_passports_fields(state, [head | tail]) do
    new_state = case head do
      %{byr: _byr, iyr: _iyr, eyr: _eyr, hgt: _hgt, hcl: _hcl, ecl: _ecl, pid: _pid} -> %{state | semi_valid_passports: [head | state.semi_valid_passports]}
      _ -> state
    end
    validate_passports_fields(new_state, tail)
  end

  defp validate_passports_values(state), do: validate_passports_values(state, state.semi_valid_passports)
  defp validate_passports_values(state, []), do: state
  defp validate_passports_values(state, [head | tail]) do
    value_state = validate_values(head)
    IO.puts(inspect(value_state))
    new_state = case value_state.valid do
      true -> %{state | valid_passports: [head | state.valid_passports]}
      false -> state
    end
    validate_passports_values(new_state, tail)
  end

  defp validate_values(passport) do
    validate_byr(%{valid: true}, passport.byr)
    |> validate_iyr(passport.iyr)
    |> validate_eyr(passport.eyr)
    |> validate_hgt(passport.hgt)
    |> validate_hcl(passport.hcl)
    |> validate_ecl(passport.ecl)
    |> validate_pid(passport.pid)
  end

  defp validate_byr(state, byr) do
    case Integer.parse(byr) do
      {value, _} -> %{state | valid: String.length(byr) == 4 and value >= 1920 && value <= 2002}
      :error -> %{state | valid: false}
    end
  end

  defp validate_iyr(state, _) when state.valid != true, do: state
  defp validate_iyr(state, iyr) do
    case Integer.parse(iyr) do
      {value, _} -> %{state | valid: String.length(iyr) == 4 and value >= 2010 && value <= 2020}
      :error -> %{state | valid: false}
    end
  end

  defp validate_eyr(state, _) when state.valid != true, do: state
  defp validate_eyr(state, eyr) do
    case Integer.parse(eyr) do
      {value, _} -> %{state | valid: String.length(eyr) == 4 and value >= 2020 && value <= 2030}
      :error -> %{state | valid: false}
    end
  end

  defp validate_hgt(state, _) when state.valid != true, do: state
  defp validate_hgt(state, hgt) do
    case String.split_at(hgt, -2) do
      {height, "cm"} -> %{state | valid: can_parse_height(height) and String.to_integer(height) >= 150 && String.to_integer(height) <= 193}
      {height, "in"} -> %{state | valid: can_parse_height(height) and String.to_integer(height) >= 59 && String.to_integer(height) <= 76}
      _ -> %{state | valid: false}
    end
  end

  defp can_parse_height(height) do
    case Integer.parse(height) do
      {integer, _} -> true
      _ -> false
    end
  end

  defp validate_hcl(state, _) when state.valid != true, do: state
  defp validate_hcl(state, hcl) do
    case String.match?(hcl, ~r/^#[0-9,a-f]{6}$/) do
      true -> %{state | valid: true}
      false -> %{state | valid: false}
    end
  end

  defp validate_ecl(state, _) when state.valid != true, do: state
  defp validate_ecl(state, ecl) do
    case ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] do
      true -> %{state | valid: true}
      false -> %{state | valid: false}
    end
  end

  defp validate_pid(state, _) when state.valid != true, do: state
  defp validate_pid(state, pid) do
    case String.match?(pid, ~r/^\d{9}$/) do
      true -> %{state | valid: true}
      false -> %{state | valid: false}
    end
  end
end

Advent4a.go(input)
