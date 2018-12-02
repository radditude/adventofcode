defmodule AdventOfCode2018.DayOne do
	@inputs %{
    real: ~S(), # paste raw input
    test: ~S(+3 +3 +4 -2 -4)
	}

	@use_test_input true

  def input_string do
    if @use_test_input, do: @inputs.test, else: @inputs.real
	end

	def parse_input do
		input_string()
		|> String.split(~r/\s+/, [trim: true])
		|> Enum.map(&String.to_integer/1)
	end

	def part_one do
		parse_input()
		|> Enum.sum()
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
	end
end

IO.puts "Part one: #{AdventOfCode2018.DayOne.part_one}"
IO.puts "Part two: #{AdventOfCode2018.DayOne.part_two}"
