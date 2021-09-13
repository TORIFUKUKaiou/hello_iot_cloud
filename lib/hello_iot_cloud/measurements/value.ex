defmodule HelloIotCloud.Measurements.Value do
  use Ecto.Schema
  import Ecto.Changeset

  schema "values" do
    field :humidity, :float
    field :temperature, :float
    belongs_to :user, HelloIotCloud.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(value, attrs) do
    value
    |> cast(attrs, [:humidity, :temperature, :user_id])
    |> validate_required([:humidity, :temperature, :user_id])
  end
end
