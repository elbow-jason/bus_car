defmodule BusCar.Filter do

  def stopwords_filter(words) when words |> is_list do
    %{
      stopwords_filter: %{
        type: "stop",
        stopwords: words
      }
    }
  end


end
