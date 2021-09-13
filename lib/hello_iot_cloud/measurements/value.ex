defmodule HelloIotCloud.Measurements.Value do
  use Ecto.Schema
  import Ecto.Changeset

  schema "values" do
    field :humidity, :float
    field :temperature, :float
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(value, attrs) do
    value
    |> cast(attrs, [:humidity, :temperature])
    |> validate_required([:humidity, :temperature])
  end
end
