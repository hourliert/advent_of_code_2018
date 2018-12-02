defmodule AdventOfCode.Two do
  def checksum do
    File.stream!("input/2")
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({0, 0}, fn line, {twos, threes} ->
      {twos_per_line, threes_per_line} = twos_threes(line)
      {twos + twos_per_line, threes + threes_per_line}
    end)
    |> twos_time_threes
  end

  def common_letters do
    ids =
      File.stream!("input/2")
      |> Stream.map(&String.trim/1)
      |> Enum.into([])

    quadratic_ids = for id1 <- ids, id2 <- ids, do: {id1, id2}

    Enum.reduce_while(quadratic_ids, nil, fn {id1, id2}, nil ->
      side_by_side = Enum.zip(String.graphemes(id1), String.graphemes(id2))

      case Enum.count(side_by_side, fn {c1, c2} -> c1 != c2 end) do
        # differ by only one
        1 -> {:halt, {id1, id2}}
        _ -> {:cont, nil}
      end
    end)
    |> remove_uncommon
  end

  defp twos_threes(line) do
    values =
      String.graphemes(line)
      |> Enum.reduce(%{}, fn letter, acc ->
        key = String.to_atom(letter)
        Map.update(acc, key, 1, &(&1 + 1))
      end)
      |> Map.values()
      |> Enum.uniq()

    {Enum.count(values, &(&1 == 2)), Enum.count(values, &(&1 == 3))}
  end

  defp twos_time_threes({twos, threes}) do
    twos * threes
  end

  defp remove_uncommon({id1, id2}) do
    side_by_side = Enum.zip(String.graphemes(id1), String.graphemes(id2))
    uncommon_index = Enum.find_index(side_by_side, fn {c1, c2} -> c1 != c2 end)

    String.slice(id1, 0..(uncommon_index - 1)) <> String.slice(id1, (uncommon_index + 1)..-1)
  end
end
