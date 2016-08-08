defmodule Bezoar.Effect do
  def apply(targ, ["dmg", xx]) do
    hp = max(0, targ[:hp] - xx)
    
    %{targ | 
      hp: hp,
      dead: hp == 0,
    }
  end


end
