defmodule AdventOfCode.One do
  def part_one do
    File.stream!("input/1")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part_two do
    File.stream!("input/1")
    |> Stream.cycle()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.reduce_while({0, MapSet.new([0])}, fn i, {current, seen} ->
      frequency = current + i

      if MapSet.member?(seen, frequency) do
        {:halt, frequency}
      else
        {:cont, {frequency, MapSet.put(seen, frequency)}}
      end
    end)
  end
end
