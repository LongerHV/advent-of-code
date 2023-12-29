defmodule Aoc.Day02part2 do
  @spec main(binary) :: integer
  def main(data) do
    parse_record = fn s ->
      [count, color] = String.split(s)
      {String.to_integer(count), color}
    end

    parse_set = fn s ->
      s
      |> String.split(", ")
      |> Enum.map(parse_record)
    end

    parse_game = fn s ->
      s
      |> String.split(": ")
      |> Enum.at(1)
      |> String.split("; ")
      |> Enum.map(parse_set)
      |> Enum.concat()
    end

    process_color = fn color, flat_game ->
      flat_game
      |> Enum.filter(fn record -> elem(record, 1) == color end)
      |> Enum.map(fn record -> elem(record, 0) end)
      |> Enum.max()
    end

    process_game = fn flat_game ->
      flat_game
      |> Enum.map(fn record -> elem(record, 1) end)
      |> Enum.uniq()
      |> Enum.reduce(1, fn color, acc -> acc * process_color.(color, flat_game) end)
    end

    data
    |> String.split("\n")
    |> Enum.filter(fn s -> s != "" end)
    |> Enum.map(parse_game)
    |> Enum.map(process_game)
    |> Enum.sum()
  end
end
