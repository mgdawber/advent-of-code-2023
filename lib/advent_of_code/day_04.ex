defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> AdventOfCode.Day04.Parser.parse()
    |> Enum.map(&matches/1)
    |> Enum.map(&pow/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> AdventOfCode.Day04.Parser.parse()
    |> total_cards()
    |> Map.values()
    |> Enum.sum()
  end

  defp matches(%{winning: winning, scratch: scratch}) do
    scratch 
    |> Enum.filter(&(&1 in winning)) 
    |> length()
  end

  defp total_cards(cards) do
    counts = Map.new(cards, &{&1.id, 1})

    Enum.reduce(cards, counts, fn %{id: id} = card, counts ->
      next = id + 1
      last = next + matches(card) - 1
      count = Map.get(counts, id)

      Enum.reduce(next..last//1, counts, fn id, counts ->
        Map.update!(counts, id, &(&1 + count))
      end)
    end)
  end

  defp pow(n), do: :math.pow(2, n - 1) |> round()
end

defmodule AdventOfCode.Day04.Parser do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/^Card +/, ""))
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(&to_struct/1)
  end

  defp to_struct([id, numbers]) do
    [winning, scratch] = String.split(numbers, " | ")

    %{id: String.to_integer(id), winning: to_number(winning), scratch: to_number(scratch)}
  end

  defp to_number(str) do
    str 
    |> String.trim() 
    |> String.split() 
    |> Enum.map(&String.to_integer/1)
  end
end
