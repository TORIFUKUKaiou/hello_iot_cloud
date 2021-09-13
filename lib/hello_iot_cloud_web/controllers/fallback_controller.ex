defmodule HelloIotCloudWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use HelloIotCloudWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, :value, %Ecto.Changeset{} = changeset, %{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(HelloIotCloudWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :user, %Ecto.Changeset{} = changeset, %{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(HelloIotCloudWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(HelloIotCloudWeb.ErrorView)
    |> render(:"404")
  end
end
