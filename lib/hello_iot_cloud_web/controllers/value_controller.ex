defmodule HelloIotCloudWeb.ValueController do
  use HelloIotCloudWeb, :controller

  alias HelloIotCloud.Measurements
  alias HelloIotCloud.Measurements.Value

  action_fallback HelloIotCloudWeb.FallbackController

  def index(conn, _params) do
    values = Measurements.list_values()
    render(conn, "index.json", values: values)
  end

  def create(conn, %{"value" => value_params}) do
    with {:ok, %Value{} = value} <- Measurements.create_value(value_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.value_path(conn, :show, value))
      |> render("show.json", value: value)
    end
  end

  def show(conn, %{"id" => id}) do
    value = Measurements.get_value!(id)
    render(conn, "show.json", value: value)
  end

  def update(conn, %{"id" => id, "value" => value_params}) do
    value = Measurements.get_value!(id)

    with {:ok, %Value{} = value} <- Measurements.update_value(value, value_params) do
      render(conn, "show.json", value: value)
    end
  end

  def delete(conn, %{"id" => id}) do
    value = Measurements.get_value!(id)

    with {:ok, %Value{}} <- Measurements.delete_value(value) do
      send_resp(conn, :no_content, "")
    end
  end
end
