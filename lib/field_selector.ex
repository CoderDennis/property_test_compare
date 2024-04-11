defmodule FieldSelector do
  def whitelist(fields, whitelist) do
    whitelist_strings = Enum.map(whitelist, &Atom.to_string/1)
    Enum.filter(fields, fn f -> Enum.member?(whitelist_strings, f) end)
  end
end
