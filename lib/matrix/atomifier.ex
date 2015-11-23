defmodule Matrix.Atomifier do
  @moduledoc"""
  Module that handles atomifying of JSON response.
  """

  defp atom_key(x) when is_bitstring(x) do
    String.to_atom(x)
  end

  defp atom_val(x) when is_map(x) do
    Enum.into(x, %{}, fn {k,v} -> {atom_key(k), atom_val(v)} end)
  end

  defp atom_val(x) when is_list(x) do
    Enum.map(x, fn item -> atom_val(item) end)
  end

  defp atom_val(x) do
    x
  end

  def atomify(x) when is_map x do
    Enum.into(x, %{}, fn {key, value} -> {atom_key(key), atom_val(value)} end)
  end
end
