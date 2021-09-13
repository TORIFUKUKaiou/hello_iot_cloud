defmodule HelloIotCloudWeb.ValueControllerTest do
  use HelloIotCloudWeb.ConnCase

  alias HelloIotCloud.Measurements
  alias HelloIotCloud.Measurements.Value

  @create_attrs %{
    humidity: 120.5,
    temperature: 120.5
  }
  @update_attrs %{
    humidity: 456.7,
    temperature: 456.7
  }
  @invalid_attrs %{humidity: nil, temperature: nil}

  def fixture(:value) do
    {:ok, value} = Measurements.create_value(@create_attrs)
    value
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all values", %{conn: conn} do
      conn = get(conn, Routes.value_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create value" do
    test "renders value when data is valid", %{conn: conn} do
      conn = post(conn, Routes.value_path(conn, :create), value: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.value_path(conn, :show, id))

      assert %{
               "id" => id,
               "humidity" => 120.5,
               "temperature" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.value_path(conn, :create), value: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update value" do
    setup [:create_value]

    test "renders value when data is valid", %{conn: conn, value: %Value{id: id} = value} do
      conn = put(conn, Routes.value_path(conn, :update, value), value: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.value_path(conn, :show, id))

      assert %{
               "id" => id,
               "humidity" => 456.7,
               "temperature" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, value: value} do
      conn = put(conn, Routes.value_path(conn, :update, value), value: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete value" do
    setup [:create_value]

    test "deletes chosen value", %{conn: conn, value: value} do
      conn = delete(conn, Routes.value_path(conn, :delete, value))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.value_path(conn, :show, value))
      end
    end
  end

  defp create_value(_) do
    value = fixture(:value)
    %{value: value}
  end
end
