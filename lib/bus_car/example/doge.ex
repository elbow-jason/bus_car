defmodule Example.Doge do
  use BusCar.Mapping

  document "animal", "dog" do
    property :name, :string
    property :age,  :integer

    timestamps
  end

end
