defmodule HelloIotCloud.Measurements do
  @moduledoc """
  The Measurements context.
  """

  import Ecto.Query, warn: false
  alias HelloIotCloud.Repo

  alias HelloIotCloud.Measurements.Value

  @doc """
  Returns the list of values.

  ## Examples

      iex> list_values()
      [%Value{}, ...]

  """
  def list_values do
    Repo.all(Value)
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
  def get_value!(id), do: Repo.get!(Value, id)

  @doc """
  Creates a value.

  ## Examples

      iex> create_value(%{field: value})
      {:ok, %Value{}}

      iex> create_value(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_value(attrs \\ %{}) do
    %Value{}
    |> Value.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a value.

  ## Examples

      iex> update_value(value, %{field: new_value})
      {:ok, %Value{}}

      iex> update_value(value, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_value(%Value{} = value, attrs) do
    value
    |> Value.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a value.

  ## Examples

      iex> delete_value(value)
      {:ok, %Value{}}

      iex> delete_value(value)
      {:error, %Ecto.Changeset{}}

  """
  def delete_value(%Value{} = value) do
    Repo.delete(value)
  end

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
