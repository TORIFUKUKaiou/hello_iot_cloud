defmodule HelloIotCloud.Accounts do
  import Ecto.Query, warn: false
  alias HelloIotCloud.Repo

  alias HelloIotCloud.Accounts.User

  def insert_and_get_user(attrs) do
    case create_user(attrs) do
      {:ok, %HelloIotCloud.Accounts.User{name: name}} ->
        {:ok, get_user(name)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
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
