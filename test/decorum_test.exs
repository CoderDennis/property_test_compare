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
  # @tag :skip
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
end
