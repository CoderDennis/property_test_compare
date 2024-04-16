defmodule DecorumTest do
  use ExUnit.Case
  import Decorum

  def good_fields(whitelist) do
    Enum.map(whitelist, &Atom.to_string/1)
  end

  def whitelist do
    atom()
    |> list_of()
    |> map(fn list ->
      Enum.uniq(list)
    end)
  end

  # fails with seed 751478
  # this and StreamData test fail with 66194, 109412
  describe "whitelist/2" do
    test "property returns only the whitelisted fields" do
      [whitelist(), list_of(binary())]
      |> zip()
      |> check_all(fn {whitelist, garbage} ->
        real = good_fields(whitelist)
        fields = real ++ garbage
        assert FieldSelector.whitelist(fields, whitelist) == real
      end)
    end
  end

  describe "trivial properties" do
    test "property all integers that are multiples of 100 are less than 321" do
      check_all(integer(0..9000//100), fn x ->
        assert x < 321
      end)
    end
  end
end
