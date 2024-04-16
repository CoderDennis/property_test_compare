defmodule StreamDataTest do
  use ExUnit.Case
  use ExUnitProperties

  # from https://github.com/whatyouhide/stream_data/issues/107

  def good_fields(whitelist) do
    sized(fn size ->
      whitelist
      |> one_of
      |> list_of(min_length: size)
      |> map(fn list -> Enum.map(list, &Atom.to_string/1) end)
    end)
  end

  def whitelist do
    atom(:alphanumeric)
    |> list_of(min_length: 1)
    |> map(fn list ->
      Enum.uniq(list)
    end)
  end

  # fails with seeds 26804, 983531, 80014, 738262, 739406, 625478
  # seed 911465 provides a short example case
  describe "whitelist/2" do
    property "returns only the whitelisted fields" do
      check all(
              whitelist <- whitelist(),
              real <- good_fields(whitelist),
              garbage <- scale(list_of(binary()), &(&1 * 4))
            ) do
        # assert Enum.count(whitelist) == Enum.count(real)
        fields = real ++ garbage
        assert FieldSelector.whitelist(fields, whitelist) == real
      end
    end
  end

  describe "trivial properties" do
    property "all integers that are multiples of 100 are less than 321" do
      check all(x <- integer(0..9000//100)) do
        assert x < 321
      end
    end
  end
end
