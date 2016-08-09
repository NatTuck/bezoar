defmodule Bezoar.Util do
  def keys_to_string(mm) do
    mm = Enum.map mm, fn {kk, vv} ->
      {to_string(kk), vv}
    end
    Enum.into(mm, %{})
  end

  def to_int(ss) when is_binary(ss) do
    {nn, _} = Integer.parse(ss)
    nn
  end

  def to_int(nn) when is_integer(nn) do
    nn
  end
end
