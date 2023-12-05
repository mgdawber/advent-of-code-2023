defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> parse_cards
    |> Enum.map(&count_matches/1)
    |> Enum.map(&doubled_power_of_two/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_cards
    |> count_total_cards
    |> Map.values()
    |> Enum.sum()
  end

  defp parse_cards(cards) do
    cards
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/^Card +/, ""))
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [card_id, numbers] ->
      [winning, scratch] = String.split(numbers, " | ")

      %{
        card_id: String.to_integer(card_id),
        winning_numbers: parse_number_string(winning),
        scratch_numbers: parse_number_string(scratch)
      }
    end)
  end

  defp parse_number_string(str) do
    str
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp count_matches(%{
         card_id: _card_id,
         winning_numbers: winning_numbers,
         scratch_numbers: scratch_numbers
       }) do
    scratch_numbers
    |> Enum.filter(&(&1 in winning_numbers))
    |> length()
  end

  defp count_total_cards(cards) do
    counts = Map.new(cards, &{&1.card_id, 1})

    Enum.reduce(cards, counts, fn %{card_id: card_id} = card, counts ->
      next = card_id + 1
      last = next + count_matches(card) - 1
      count = Map.get(counts, card_id)

      Enum.reduce(next..last//1, counts, fn card_id, counts ->
        Map.update!(counts, card_id, &(&1 + count))
      end)
    end)
  end

  defp doubled_power_of_two(0), do: 0
  defp doubled_power_of_two(n) when n >= 1, do: :math.pow(2, n - 1) |> round()
end
