defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Stream.map(&get_first_last_digit/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Stream.map(&get_first_last_digit_with_text/1)
    |> Enum.sum()
  end

  defp get_first_last_digit(value) do
    digits = get_row_digits(value)
    first = hd(digits)
    last = hd(Enum.reverse(digits))
    String.to_integer(first <> last)
  end

  defp get_first_last_digit_with_text(value) do
    digits = get_row_digits_with_text(value)
    first = hd(digits)
    last = hd(Enum.reverse(digits))
    10 * first + last
  end

  defp get_row_digits(value) do
    value
    |> String.codepoints()
    |> Enum.filter(&String.match?(&1, ~r/[0-9]/))
  end

  defp get_row_digits_with_text(row) do
    regex = ~r/[0-9]|zero|one|two|three|four|five|six|seven|eight|nine/
    regex_run = Regex.run(regex, row, return: :index)

    case regex_run do
      nil ->
        []

      [{start, len}] ->
        value =
          row
          |> String.slice(start, len)
          |> parse_string_value()

        {_, rest} = row |> String.split_at(start + 1)

        [value | get_row_digits_with_text(rest)]
    end
  end

  defp parse_string_value("zero"), do: 0
  defp parse_string_value("one"), do: 1
  defp parse_string_value("two"), do: 2
  defp parse_string_value("three"), do: 3
  defp parse_string_value("four"), do: 4
  defp parse_string_value("five"), do: 5
  defp parse_string_value("six"), do: 6
  defp parse_string_value("seven"), do: 7
  defp parse_string_value("eight"), do: 8
  defp parse_string_value("nine"), do: 9
  defp parse_string_value(digit), do: String.to_integer(digit)
end
