defmodule HelloIotCloud.MeasurementsTest do
  use HelloIotCloud.DataCase

  alias HelloIotCloud.Measurements

  describe "values" do
    alias HelloIotCloud.Measurements.Value

    @valid_attrs %{humidity: 120.5, temperature: 120.5}
    @update_attrs %{humidity: 456.7, temperature: 456.7}
    @invalid_attrs %{humidity: nil, temperature: nil}

    def value_fixture(attrs \\ %{}) do
      {:ok, value} =
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
      assert {:ok, %Value{} = value} = Measurements.create_value(@valid_attrs)
      assert value.humidity == 120.5
      assert value.temperature == 120.5
    end

    test "create_value/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Measurements.create_value(@invalid_attrs)
    end

    test "update_value/2 with valid data updates the value" do
      value = value_fixture()
      assert {:ok, %Value{} = value} = Measurements.update_value(value, @update_attrs)
      assert value.humidity == 456.7
      assert value.temperature == 456.7
    end

    test "update_value/2 with invalid data returns error changeset" do
      value = value_fixture()
      assert {:error, %Ecto.Changeset{}} = Measurements.update_value(value, @invalid_attrs)
      assert value == Measurements.get_value!(value.id)
    end

    test "delete_value/1 deletes the value" do
      value = value_fixture()
      assert {:ok, %Value{}} = Measurements.delete_value(value)
      assert_raise Ecto.NoResultsError, fn -> Measurements.get_value!(value.id) end
    end

    test "change_value/1 returns a value changeset" do
      value = value_fixture()
      assert %Ecto.Changeset{} = Measurements.change_value(value)
    end
  end
end
