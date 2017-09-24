alias BusCar.Api
alias BusCar.Cluster
alias BusCar.Index
alias BusCar.Query
alias BusCar.Search
alias BusCar.Dsl
alias BusCar.Document

alias Example.Repo
alias Example.Doge

defmodule ExampleRepo do
  use BusCar.Repo,
    otp_app: :dev_example,
    headers: [{"flim", "flam"}]
end

defmodule ExampleDoc do
  use BusCar.Document
  document "dev_example", "example_doc" do
    property :name, :string
    property :favorite_color, :string
  end
end