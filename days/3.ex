defmodule AdventOfCode2018.DayThree do
	@inputs %{
    real: ~S(
    ), #paste raw input
    test: ~S(
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      #4 @ 3,3: 2x2
    )
	}

	@use_test_input true

  def input_string do
    if @use_test_input, do: @inputs.test, else: @inputs.real
	end

	def parse_input do
    input_string()
    |> String.split(~r/\n(\s+)/, [trim: true])
    |> Enum.map(fn claim ->
      [id, beginning, size] = String.split(claim, ~r/#| @ |: /, [trim: true])
      [column, row] = String.split(beginning, ",")
      [width, height] = String.split(size, "x")
      {column, _} = Integer.parse(column)
      {row, _} = Integer.parse(row)
      {width, _} = Integer.parse(width)
      {height, _} = Integer.parse(height)

      {id, column..column + width - 1, row..row + height - 1}
    end)
  end

	def part_one do
    {_seen, double_claimed} = parse_input()
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {_id, x_range, y_range}, {seen, double_claimed} ->
      Enum.reduce(x_range, {seen, double_claimed}, fn x, {seen, double_claimed} ->
        Enum.reduce(y_range, {seen, double_claimed}, fn y, {seen, double_claimed} ->
          square = {x, y}

          if MapSet.member?(seen, square) do
            {seen, MapSet.put(double_claimed, square)}
          else
            {MapSet.put(seen, square), double_claimed}
          end
        end)
      end)
    end)

    MapSet.size(double_claimed)
	end

  def part_two do
    parse_input()
    |> Enum.map(fn {id, x_range, y_range} ->

      claim = Enum.reduce(x_range, MapSet.new(), fn x, claim ->
        Enum.reduce(y_range, claim, fn y, claim ->
          square = {x, y}
          MapSet.put(claim, square)
        end)
      end)

      {id, claim}
    end)
    |> (fn claims_list ->
      Enum.reduce_while(claims_list, "", fn {id, claim}, _acc ->
        minus_current = List.delete(claims_list, {id, claim})

        if Enum.all?(minus_current, fn {_second_id, second_claim} ->
          MapSet.disjoint?(claim, second_claim)
        end) do
          {:halt, id}
        else
          {:cont, ""}
        end
      end)
    end).()
	end
end

IO.puts "Part one: #{AdventOfCode2018.DayThree.part_one}"
IO.puts "Part two: #{AdventOfCode2018.DayThree.part_two}"
