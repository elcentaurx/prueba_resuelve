defmodule PruebaWeb.PageLive do
  use PruebaWeb, :live_view
  alias Prueba.PageHandler

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      json_in: "",
      json_print: "",
      resuelveFC_goal: individual_goal_data()
    )}
  end

  def handle_event("update_json", %{"text_area_json" => json}, socket) do
    {:noreply, assign(socket, json_in: json)}
  end

  def handle_event("send_json", _params, socket) do
    json = socket.assigns.json_in
    resuelveFC_goal = socket.assigns.resuelveFC_goal
    json
      |> Poison.decode()
        |> case do
          {:ok, data} ->
              calculate_total_salary(data, resuelveFC_goal)
              |> Enum.map(fn f -> f |> Map.put("sueldo_completo", f["sueldo_completo"] |>  Float.to_string(decimals: 2) ) end)
              |> Poison.encode!
              |> case do
                data ->
                  {:noreply, assign(socket, json_print: data)}
                _any ->
                  {:noreply, assign(socket, json_print: "error processing")}
              end
          {:error, _any} ->
              {:noreply, assign(socket, json_print: "Error: json malformed")}
        end
  end

  defp calculate_total_salary(json_parced, resuelveFC_map ) do
    json_parced |> PageHandler.calculate_total_salary(resuelveFC_map)
  end

  defp individual_goal_data() do
    [
      %{level: "A", value: 5},
      %{level: "B", value: 10},
      %{level: "C", value: 15},
      %{level: "Cuauh", value: 20}
    ]
  end
end
