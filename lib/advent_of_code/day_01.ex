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
    String.to_integer(hd(row_digits(value)) <> List.last(row_digits(value)))
  end

  defp get_first_last_digit_with_text(value) do
    10 * hd(row_digits_text(value)) + List.last(row_digits_text(value))
  end

  defp row_digits(value) do
    value |> String.codepoints() |> Enum.filter(&String.match?(&1, ~r/[0-9]/))
  end

  defp row_digits_text(row) do
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

        [value | row_digits_text(rest)]
    end
  end

  def parse_string_value(value) do
    case value do
      "zero" -> 0
      "one" -> 1
      "two" -> 2
      "three" -> 3
      "four" -> 4
      "five" -> 5
      "six" -> 6
      "seven" -> 7
      "eight" -> 8
      "nine" -> 9
      integer -> String.to_integer(integer)
    end
  end
end
