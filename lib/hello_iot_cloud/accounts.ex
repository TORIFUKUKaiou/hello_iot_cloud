defmodule HelloIotCloud.Accounts do
  import Ecto.Query, warn: false
  alias HelloIotCloud.Repo

  alias HelloIotCloud.Accounts.User
  alias HelloIotCloud.Measurements.Value

  def insert_and_get_user(attrs) do
    case create_user(attrs) do
      {:ok, %HelloIotCloud.Accounts.User{name: name}} ->
        {:ok, get_user(name)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  def list_with_last_value do
    Repo.all(User)
    |> Repo.preload(
      values: from(v in Value, distinct: v.user_id, order_by: [desc: v.inserted_at])
    )
  end

  defp create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  defp get_user(name) do
    Repo.one(from u in User, where: u.name == ^name)
  end
end
