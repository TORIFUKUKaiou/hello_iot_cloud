defmodule HelloIotCloud.Measurements do
  @moduledoc """
  The Measurements context.
  """

  import Ecto.Query, warn: false
  alias HelloIotCloud.Repo

  alias HelloIotCloud.Measurements.Value
  alias HelloIotCloud.Accounts.User

  def subscribe do
    Phoenix.PubSub.subscribe(HelloIotCloud.PubSub, "values")
  end

  @doc """
  Returns the list of values.

  ## Examples

      iex> list_values()
      [%Value{}, ...]

  """
  def list_values do
    Repo.all(from v in Value, preload: [:user])
  end

  @doc """
  Gets a single value.

  Raises `Ecto.NoResultsError` if the Value does not exist.

  ## Examples

      iex> get_value!(123)
      %Value{}

      iex> get_value!(456)
      ** (Ecto.NoResultsError)

  """
  def get_value!(id), do: Repo.get!(Value, id) |> Repo.preload([:user])

  @doc """
  Creates a value.

  ## Examples

      iex> create_value(%{field: value})
      {:ok, %Value{}}

      iex> create_value(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_value(attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:user, fn _repo, _changes ->
      HelloIotCloud.Accounts.insert_and_get_user(attrs)
    end)
    |> Ecto.Multi.run(:value, fn _repo, %{user: user} ->
      attrs =
        if Map.keys(attrs) |> Enum.all?(&is_atom(&1)) do
          Map.merge(attrs, %{user_id: user.id})
        else
          Map.merge(attrs, %{"user_id" => user.id})
        end

      %Value{user: user}
      |> Value.changeset(attrs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> broadcast(:value_created)
  end

  def broadcast({:ok, %{value: %Value{} = value, user: %User{} = user}}, event) do
    Phoenix.PubSub.broadcast(
      HelloIotCloud.PubSub,
      "values",
      {event, value}
    )

    {:ok, %{value: value, user: user}}
  end

  def broadcast({:error, _, _, _} = error, _event), do: error

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking value changes.

  ## Examples

      iex> change_value(value)
      %Ecto.Changeset{data: %Value{}}

  """
  def change_value(%Value{} = value, attrs \\ %{}) do
    Value.changeset(value, attrs)
  end
end
