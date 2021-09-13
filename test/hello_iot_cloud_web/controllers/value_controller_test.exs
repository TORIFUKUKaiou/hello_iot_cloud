defmodule HelloIotCloudWeb.ValueControllerTest do
  use HelloIotCloudWeb.ConnCase

  alias HelloIotCloud.Measurements

  @create_attrs %{
    name: "awesome",
    humidity: 120.5,
    temperature: 120.5
  }
  @invalid_attrs %{name: "awesome", humidity: nil, temperature: nil}
  @invalid_attrs2 %{name: nil, humidity: nil, temperature: nil}

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
               "id" => ^id,
               "humidity" => 120.5,
               "temperature" => 120.5,
               "name" => "awesome"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.value_path(conn, :create), value: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when data is invalid 2", %{conn: conn} do
      conn = post(conn, Routes.value_path(conn, :create), value: @invalid_attrs2)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
