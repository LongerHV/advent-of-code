defmodule Aoc.Day02part1 do
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
      [part1, part2] = String.split(s, ": ")
      ["Game", id] = String.split(part1)

      sets =
        part2
        |> String.split("; ")
        |> Enum.map(parse_set)

      {String.to_integer(id), sets}
    end

    check_in_bag = fn
      {count, color} ->
        case color do
          "red" -> count <= 12
          "green" -> count <= 13
          "blue" -> count <= 14
        end
    end

    process_game = fn
      {game_id, game} ->
        is_playable =
          Enum.all?(game, fn set ->
            set
            |> Enum.map(check_in_bag)
            |> Enum.all?()
          end)

        if is_playable do
          game_id
        else
          0
        end
    end

    data
    |> String.split("\n")
    |> Enum.filter(fn s -> s != "" end)
    |> Enum.map(parse_game)
    |> Enum.map(process_game)
    |> Enum.sum()
  end
end
