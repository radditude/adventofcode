defmodule AdventOfCode2018.DayTwo do
	@inputs %{
    real: ~S(

    ), #paste raw input
    test: ~S(
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
    )
	}

	@use_test_input false

  def input_string do
    if @use_test_input, do: @inputs.test, else: @inputs.real
	end

	def parse_input do
    input_string()
		|> String.split(~r/\n(\s+)/, [trim: true])
  end

  def parse_count(list, count) do
    if Enum.any?(list, &(Enum.count(&1) == count)), do: 1, else: 0
  end

	def part_one do
    {two_letters, three_letters} = parse_input()
      |> Enum.reduce({0, 0}, fn id, {double_letter_count, triple_letter_count} ->
        id
        |> String.graphemes()
        |> Enum.sort()
        |> Enum.chunk_by(fn char -> char end)
        |> (fn (chunk_list) ->
          {double_letter_count + parse_count(chunk_list, 2), triple_letter_count + parse_count(chunk_list, 3)}
        end).()
      end)

    two_letters * three_letters
	end

	def part_two do
    id_list = parse_input()

    {diff} = Enum.reduce_while(id_list, {}, fn first_id, _acc ->
      id_list_compare = Enum.reject(id_list, &(&1 == first_id))

      case Enum.reduce_while(id_list_compare, {}, fn second_id, _acc ->
        diff = String.myers_difference(first_id, second_id)
        [first | rest] = diff
          |> Keyword.get_values(:del)

        if Enum.count(rest) == 0 && String.length(first) == 1 do
          {:halt, {diff}}
        else
          {:cont, {}}
        end
      end) do
        {diff} -> {:halt, {diff}}
        {} -> {:cont, {}}
      end
    end)

    diff
    |> Enum.map(fn {key, value} ->
      if key == :del || key == :ins, do: nil, else: value
    end)
    |> Enum.join()
	end
end

IO.puts "Part one: #{AdventOfCode2018.DayTwo.part_one}"
IO.puts "Part two: #{AdventOfCode2018.DayTwo.part_two}"
