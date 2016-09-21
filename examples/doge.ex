defmodule Doge do
  use BusCar.Query

  def match_doge do
    [
      match(:such, :api),
      match(:many, :dsl),
    ]
  end
end
