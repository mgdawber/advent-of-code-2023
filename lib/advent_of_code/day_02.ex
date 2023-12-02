defmodule AdventOfCode.Day02 do
  @maxRed 12
  @maxGreen 13
  @maxBlue 14

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
    |> Enum.filter(&is_valid/1)
    |> Enum.reduce(0, fn map, acc ->
      Map.keys(map) |> Enum.reduce(acc, &(&1 + &2))
    end)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
    |> Enum.map(&sum_highest_values/1)
    |> Enum.sum()
  end

  defp parse_row(row) do
    row
    |> String.slice(5..-1)
    |> String.replace(";", ",")
    |> String.split(":", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&{Enum.at(&1, 0), Enum.at(&1, 1)})
    |> Enum.map(fn {key, value} ->
      {String.to_integer(key),
        value
        |> String.split(~r/, /, trim: true)
        |> Enum.map(&String.split(&1, " "))
        |> Enum.map(&{Enum.at(&1, 1), String.to_integer(Enum.at(&1, 0))})}
    end)
    |> Map.new()
  end

  defp is_valid(map) do
    map
    |> Enum.all?(&is_list_valid/1)
  end

  defp is_list_valid({_key, list}) do
    list
    |> Enum.all?(&is_entry_valid/1)
  end

  defp is_entry_valid({colour, count}) do
    cond do
      colour == "red" and count > @maxRed -> false
      colour == "green" and count > @maxGreen -> false
      colour == "blue" and count > @maxBlue -> false
      true -> true
    end
  end

  defp sum_highest_values(map) do
    map
    |> Map.to_list()
    |> hd()
    |> elem(1)
    |> Enum.reduce(%{}, fn {color, val}, acc ->
      Map.update(acc, color, val, &max(&1, val))
    end)
    |> Map.values()
    |> Enum.reduce(1, &Kernel.*/2)
  end
end
