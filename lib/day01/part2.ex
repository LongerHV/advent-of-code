defmodule Aoc.Day01part2 do
  def is_digit(s) do
    s >= 48 and s < 58
  end

  def get_textual_digit_from_line_start(line) do
    translations = %{
      one: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5,
      six: 6,
      seven: 7,
      eight: 8,
      nine: 9
    }

    first_match = fn key ->
      if String.starts_with?(line, Atom.to_string(key)) do
        translations[key]
      else
        nil
      end
    end

    List.first(Enum.filter(Enum.map(Map.keys(translations), first_match), fn x -> x != nil end))
  end

  def get_digits_from_line(line) do
    cond do
      line == "" ->
        []

      line |> String.to_charlist() |> List.first() |> is_digit ->
        (line |> String.at(0) |> String.to_integer() |> List.wrap()) ++
          (line |> String.slice(1..-1) |> get_digits_from_line)

      get_textual_digit_from_line_start(line) ->
        (get_textual_digit_from_line_start(line) |> List.wrap()) ++
          (line |> String.slice(1..-1) |> get_digits_from_line)

      true ->
        [] ++ (line |> String.slice(1..-1) |> get_digits_from_line)
    end
  end

  def main(data) do
    get_calibration_value_from_line = fn line ->
      digits = get_digits_from_line(line)
      first = digits |> List.first() |> Integer.to_string()
      last = digits |> List.last() |> Integer.to_string()
      String.to_integer(first <> last)
    end

    data
    |> String.split()
    |> Enum.map(get_calibration_value_from_line)
    |> Enum.sum()
  end
end
