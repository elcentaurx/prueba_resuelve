defmodule PruebaWeb.PageLive do
  use PruebaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      json_out: "",
      json_in: "",
      resuelveFC_goal: individual_goal_data()
    )}
  end

  def handle_event("update_json", %{"text_area_json" => json}, socket) do


    {:noreply, assign(socket, json_in: json)}

  end

  def handle_event("send_json", _params, socket) do
    json_out = socket.assigns.json_out
    json = socket.assigns.json_in
    json
    |> Poison.decode()

    |> case do
      {:ok, data} -> json_out = data
          json_out = json_out |> Poison.encode
          {k, v} = json_out
        {:noreply, assign(socket, json_out: v )}
      {:error, _any} ->
        {:noreply, assign(socket, json_out: "Error: json malformed"  )}

    end


  end

  defp individual_goal_data() do
    [
    %{name: "A", value: 5},
    %{name: "B", value: 10},
    %{name: "C", value: 15},
    %{name: "Cuauh", value: 20}
    ]
  end

end
