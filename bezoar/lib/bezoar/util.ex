defmodule Bezoar.Util do
  def keys_to_string(mm) do
    mm = Enum.map mm, fn {kk, vv} ->
      {to_string(kk), vv}
    end
    Enum.into(mm, %{})
  end
end
