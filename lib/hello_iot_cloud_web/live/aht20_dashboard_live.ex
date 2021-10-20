defmodule HelloIotCloudWeb.Aht20DashboardLive do
  use HelloIotCloudWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      HelloIotCloud.Measurements.subscribe()
    end

    socket =
      socket
      |> assign(temperature: 0)
      |> assign(humidity: 0)
      |> assign(time: format_time(Timex.now()))
      |> assign(name_options: name_options())
      |> assign(name: "")

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div>
      <div>
        <form phx-change="filter">
          <div class="filters">
            <select name="name">
              <%= options_for_select(@name_options, @name) %>
            </select>
          </div>
        </form>
      </div>

      <div>
        <%= @temperature %>度
      </div>
      <div>
        <%= @humidity %>%
      </div>
      <div>
        <%= @time %>
      </div>
    </div>
    """
  end

  def handle_info({:value_created, value}, socket) do
    socket = assign(socket, name_options: name_options())

    socket =
      if socket.assigns.name == value.user.name or socket.assigns.name == "" do
        socket
        |> assign(temperature: value.temperature)
        |> assign(humidity: value.humidity)
        |> assign(time: format_time(Timex.now()))
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("filter", %{"name" => name}, socket) do
    socket =
      socket
      |> assign(name: name)

    {:noreply, socket}
  end

  defp format_time(time) do
    HelloIotCloud.Cldr.format_time(time, locale: "ja-JP", timezone: "Asia/Tokyo")
  end

  defp name_options do
    HelloIotCloud.Accounts.list_users()
    |> Enum.map(& &1.name)
    |> Enum.map(fn name ->
      {String.to_atom(name), name}
    end)
    |> List.insert_at(0, {:All, ""})
  end
end
