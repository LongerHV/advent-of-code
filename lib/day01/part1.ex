defmodule Day01part1 do
  def main(data) do
    is_digit = fn s -> s >= 48 and s < 58 end

    get_calibration_value_from_line = fn line ->
      digits = line |> String.to_charlist() |> Enum.filter(is_digit) |> Enum.to_list()
      first = digits |> List.first() |> List.wrap() |> List.to_string()
      last = digits |> List.last() |> List.wrap() |> List.to_string()
      String.to_integer(first <> last)
    end

    data
    |> String.split()
    |> Enum.map(get_calibration_value_from_line)
    |> Enum.sum()
  end
end
