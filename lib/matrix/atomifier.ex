defmodule Matrix.Atomifier do
  @moduledoc"""
  Module that handles atomifying of JSON response.
  """

  defp atom_key(x) when is_bitstring(x) do
    x
    # Atoms will have strange formatting with punctuation in them.
    # Better to simply replace everything with the canonical underscore
    |> String.replace(~r/[.:-]/, "_") 
    |> String.to_atom
  end

  defp atom_val(x) when is_map(x) do
    Enum.into(x, %{}, fn {k, v} -> {atom_key(k), atom_val(v)} end)
  end

  defp atom_val(x) when is_list(x) do
    Enum.map(x, &atom_val/1)
  end

  defp atom_val(x) do
    x
  end

  @doc"""
  Recursively atomifies a JSON object as parsed by Poison.

      iex> Matrix.Atomifier.atomify(%{"one" => [%{"two" => "three"}, [%{"four"=> "five"}]]})
      %{one: [%{two: "three"}, [%{four: "five"}]]}

      iex> Matrix.Atomifier.atomify(%{"one" => ["1", 1, 1.5], "two" => %{"three" => "four"}})
      %{one: ["1", 1, 1.5], two: %{three: "four"}}

      iex> Matrix.Atomifier.atomify(%{"m.room.message" => %{"what-e:v:e:r" => true}})
      %{m_room_message: %{what_e_v_e_r: true}}
  """
  def atomify(x) when is_map x do
    Enum.into(x, %{}, fn {key, value} -> {atom_key(key), atom_val(value)} end)
  end
end
