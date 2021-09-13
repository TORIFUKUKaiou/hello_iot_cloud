defmodule HelloIotCloud.MeasurementsTest do
  use HelloIotCloud.DataCase

  alias HelloIotCloud.Measurements

  describe "values" do
    alias HelloIotCloud.Measurements.Value

    @valid_attrs %{name: "awesome", humidity: 120.5, temperature: 120.5}
    @invalid_attrs %{name: "awesome", humidity: nil, temperature: nil}
    @invalid_attrs2 %{name: nil, humidity: nil, temperature: nil}

    def value_fixture(attrs \\ %{}) do
      {:ok, %{user: %HelloIotCloud.Accounts.User{}, value: %Value{} = value}} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Measurements.create_value()

      value
    end

    test "list_values/0 returns all values" do
      value = value_fixture()
      assert Measurements.list_values() == [value]
    end

    test "get_value!/1 returns the value with given id" do
      value = value_fixture()
      assert Measurements.get_value!(value.id) == value
    end

    test "create_value/1 with valid data creates a value" do
      assert {:ok, %{user: %HelloIotCloud.Accounts.User{}, value: %Value{} = value}} =
               Measurements.create_value(@valid_attrs)

      assert value.humidity == 120.5
      assert value.temperature == 120.5
    end

    test "create_value/1 with invalid data returns error changeset" do
      assert {:error, :value, %Ecto.Changeset{}, %{}} = Measurements.create_value(@invalid_attrs)
    end

    test "create_value/1 with invalid data returns error changeset 2" do
      assert {:error, :user, %Ecto.Changeset{}, %{}} = Measurements.create_value(@invalid_attrs2)
    end

    test "change_value/1 returns a value changeset" do
      value = value_fixture()
      assert %Ecto.Changeset{} = Measurements.change_value(value)
    end
  end
end
