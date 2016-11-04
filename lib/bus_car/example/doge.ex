# defmodule Example.Doge do
#   use BusCar.Mapping
#
#   document "animal", "dog" do
#     property :name, :string
#     property :age,  :integer
#
#     timestamps
#   end
#
#   @allowed_fields ~w(name age)a
#   @required_fields ~w(name age)a
#
#   def changeset(model, params \\ %{}) do
#     model
#     |> cast(params, @allowed_fields)
#     |> validate_required(@required_fields)
#   end
#
# end
