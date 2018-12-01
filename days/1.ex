defmodule Aoc2018.DayOne do
	import Aoc2018.DayOne.Inputs

	def parse_input do
		input_string()
		|> String.split(~r/\s+/, [trim: true])
		|> Enum.map(&String.to_integer/1)
	end

	def part_one do
		parse_input()
		|> Enum.sum()
		|> IO.inspect
	end

	def part_two do
		parse_input()
		|> Stream.cycle()
		|> Enum.reduce_while({0, MapSet.new([0])}, fn x, {current, seen} ->
			frequency = current + x
			if MapSet.member?(seen, frequency) do
				{:halt, frequency}
			else
				{:cont, {frequency, MapSet.put(seen, frequency)}}
			end
		end)
		|> IO.inspect
	end
end
