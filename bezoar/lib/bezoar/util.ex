defmodule Bezoar.Util do
  @key_strings MapSet.new [
    "active", "champs", "dead", "desc", "effect", "effects", "events",
    "hp", "hp_base", "hp_max", "id", "name", "orders", "pick", "player_id",
    "players", "posn", "range", "rules", "skills", "team",
    "active", "effect", "pick", "range"
  ]

  def to_int(ss) when is_binary(ss) do
    {nn, _} = Integer.parse(ss)
    nn
  end

  def to_int(nn) when is_integer(nn) do
    nn
  end

  def to_s(aa) when is_atom(aa) do
    to_string(aa)
  end

  def to_s(xx) do
    xx
  end

  def to_atom(ss) when is_binary(ss) do
    if MapSet.member?(@key_strings, ss) do
      String.to_atom(ss)
    else
      ss
    end
  end

  def to_atom(xx) do
    xx
  end

  def keys_to_string(mm) when is_map(mm) do
    Enum.map(mm, fn {kk, vv} ->
      {to_s(kk), keys_to_string(vv)}
    end)
    |> Enum.into(%{})
  end

  def keys_to_string(xs) when is_list(xs) do
    Enum.map xs, &keys_to_string/1
  end

  def keys_to_string(xx) do
    xx
  end

  def keys_to_atom(mm) when is_map(mm) do
    Enum.map(mm, fn {kk, vv} ->
      {to_atom(kk), keys_to_atom(vv)}
    end)
    |> Enum.into(%{})
  end

  def keys_to_atom(xs) when is_list(xs) do
    Enum.map xs, &keys_to_atom/1
  end

  def keys_to_atom(xx) do
    xx
  end
 
  def keys_in(xs) when is_map(xs) do
    Map.keys(xs) ++ Enum.flat_map(xs, fn {_, xx} -> keys_in(xx) end)
    |> Enum.into(MapSet.new)
  end

  def keys_in(xs) when is_list(xs) do
    Enum.flat_map(xs, &keys_in/1)
    |> Enum.into(MapSet.new)
  end

  def keys_in(_xx) do
    []
  end
end
