defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(2, 1)
    |> Enum.reduce({[], ""}, &get_part_numbers/2)
    |> sum_result
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&get_positions/1)
    |> Enum.chunk_every(2, 1)
    |> Enum.reduce({0, %{gears: [], numbers: []}}, &get_gear_ratios/2)
    |> get_result
  end

  defp get_part_numbers(rows, acc) do
    {result, previous_row} = acc
    [current_row | next_rows] = rows

    matching = Regex.scan(~r/\d+/, current_row, return: :index)
               |> Enum.filter(fn [{start, count}] ->
                 offset = count + min(0, start - 1)

                 top = String.slice(previous_row, max(0, start - 1), offset + 2)
                 right = String.slice(current_row, start + count, 1)
                 bottom = String.slice(Enum.at(next_rows, 0) || "", max(0, start - 1), offset + 2)
                 left = String.slice(current_row, max(0, start - 1), 1 + min(0, start - 1))
                 Enum.any?([top, right, bottom, left], &contains_symbol?/1)
               end)
               |> List.flatten
               |> Enum.map(fn {start, count} -> String.to_integer(String.slice(current_row, start, count)) end)

    {result ++ matching, current_row}
  end

  defp get_gear_ratios(rows, {result, previous_row}) do
    [current_row | next_rows] = rows
    next_row = Enum.at(next_rows, 0) || %{gears: [], numbers: []}

    row_result = current_row[:gears]
                 |> Enum.map(fn gear ->
                   [previous_row[:numbers], current_row[:numbers], next_row[:numbers]]
                   |> List.flatten
                   |> Enum.reject(&is_nil/1)
                   |> Enum.filter(fn value -> is_adjacent?(gear, value[:position]) end)
                 end)
                 |> Enum.filter(fn list -> length(list) == 2 end)
                 |> Enum.map(fn [%{value: first_value, position: _}, %{value: second_value, position: _}] ->
                   String.to_integer(first_value) * String.to_integer(second_value)
                 end)
                 |> List.flatten
                 |> Enum.sum

    {result + row_result, current_row}
  end

  defp get_positions(row) do
    %{gears: get_gear_positions(row), numbers: get_numbers_positions(row)}
  end

  defp get_gear_positions(row) do
    Regex.scan(~r/\*/, row, return: :index) |> List.flatten
  end

  defp get_numbers_positions(row) do
    Regex.scan(~r/\d+/, row, return: :index)
    |> List.flatten
    |> Enum.map(fn {start, count} -> %{ position: {start, count}, value: String.slice(row, start, count) } end)
  end

  defp sum_result({result, _}) do
    Enum.sum(result)
  end

  defp get_result({result, _}) do
    result
  end

  defp is_adjacent?(gear, number) do
    {gear_position, _} = gear
    {start, count} = number

    start - 1 <= gear_position && gear_position <= start + count
  end

  defp contains_symbol?(str) do
    Enum.any?(String.graphemes(str), fn value ->
      !Enum.member?([".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "\n"], value)
    end)
  end
end
