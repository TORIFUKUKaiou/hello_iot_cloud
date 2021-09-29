defmodule HelloIotCloud.AccountsTest do
  use HelloIotCloud.DataCase
  import Ecto.Query, warn: false

  alias HelloIotCloud.Accounts
  alias HelloIotCloud.Measurements

  describe "list_with_last_value" do
    alias HelloIotCloud.Accounts.User
    alias HelloIotCloud.Measurements.Value

    test "list_with_last_value" do
      Measurements.create_value(%{name: "awesome", humidity: 1.0, temperature: 2.0})
      Measurements.create_value(%{name: "awesome2", humidity: 3.0, temperature: 4.0})
      Repo.update_all("values", set: [inserted_at: DateTime.utc_now() |> DateTime.add(-60)])
      Measurements.create_value(%{name: "awesome", humidity: 5.0, temperature: 6.0})
      Measurements.create_value(%{name: "awesome2", humidity: 7.0, temperature: 8.0})

      assert [
               %User{name: "awesome", values: [%Value{humidity: 5.0, temperature: 6.0}]},
               %User{name: "awesome2", values: [%Value{humidity: 7.0, temperature: 8.0}]}
             ] = Accounts.list_with_last_value()
    end
  end
end
