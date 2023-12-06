defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> AdventOfCode.Day02.Parser.parse()
    |> Enum.filter(fn map -> Enum.all?(map, &is_list_valid/1) end)
    |> Enum.reduce(0, fn map, acc -> Map.keys(map) |> Enum.reduce(acc, &(&1 + &2)) end)
  end

  def part2(args) do
    args
    |> AdventOfCode.Day02.Parser.parse()
    |> Enum.map(&get_highest_values/1)
    |> Enum.sum()
  end

  defp get_highest_values(map) do
    map
    |> Map.to_list()
    |> hd()
    |> elem(1)
    |> Enum.reduce(%{}, &map_update/2)
    |> Map.values()
    |> Enum.reduce(1, &Kernel.*/2)
  end

  defp is_list_valid({_key, list}) do
    Enum.all?(list, &is_entry_valid/1)
  end

  defp map_update({key, value}, acc) do
    Map.update(acc, key, value, &max(&1, value))
  end

  defp is_entry_valid({"red", count}) when count > 12, do: false
  defp is_entry_valid({"green", count}) when count > 13, do: false
  defp is_entry_valid({"blue", count}) when count > 14, do: false
  defp is_entry_valid(_), do: true
end

defmodule AdventOfCode.Day02.Parser do
  def parse(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.slice(5..-1)
    |> String.replace(";", ",")
    |> String.split(":")
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&{Enum.at(&1, 0), Enum.at(&1, 1)})
    |> Enum.map(&map_to_struct/1)
    |> Map.new()
  end

  defp map_to_struct({key, value}) do
    {String.to_integer(key),
     value
     |> String.split(~r/, /)
     |> Enum.map(&String.split(&1))
     |> Enum.map(&{Enum.at(&1, 1), String.to_integer(Enum.at(&1, 0))})}
  end
end
