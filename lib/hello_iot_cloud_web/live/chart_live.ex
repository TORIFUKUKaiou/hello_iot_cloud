defmodule HelloIotCloudWeb.ChartLive do
  use HelloIotCloudWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update)
    end

    {:ok,
     assign(socket,
       chart_data: %{
        suggestedmin: 50,
        suggestedmax: 200
       },
       current_reading: 12
     )}
  end

  def render(assigns) do
    ~L"""
    <div id="charting">
      <h1>Title</h1>
      <div phx-update="ignore">
        <canvas id="chart-canvas"
                phx-hook="LineChart"
                data-chart-data="<%= Jason.encode!(@chart_data) %>">
        </canvas>
      </div>
      <div>
        Total readings: <%= @current_reading %>
      </div>
    </div>
    """
  end

  def handle_info(:update, socket) do
    {:noreply, add_point(socket)}
  end

  defp add_point(socket) do
    socket = update(socket, :current_reading, &(&1 + 1))

    point = %{
      label: socket.assigns.current_reading,
      value: get_reading(),
      name: "user#{1..5 |> Enum.random()}"
    }

    push_event(socket, "new-point", point)
  end

  defp get_reading do
    Enum.random(70..180)
  end
end
