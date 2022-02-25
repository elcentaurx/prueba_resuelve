defmodule PruebaWeb.PageLive do
  use PruebaWeb, :live_view
  alias Prueba.PageHandler

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      json_in: "",
      json_print: "",
      json_in_levels: "",
      resuelveFC_goal: individual_goal_data(),
      flag_other_team: false
    )}
  end



  def handle_event("update_json", %{"text_area_json" => json}, socket) do
    json |> IO.inspect(label: " json ?=_============>")

    {:noreply, assign(socket, json_in: json)}
  end

  def handle_event("update_json_levels", %{"text_area_json_levels" => json_team}, socket) do

    {:noreply, assign(socket, json_in_levels: json_team )}
  end

  def handle_event("change_team", _params, socket) do
    resuelveFC_goal = socket.assigns.resuelveFC_goal
    json_in_levels = socket.assigns.json_in_levels
      data = json_in_levels
        |> Poison.decode()
        |> case do
          {:ok, data} ->
          val =  (data |> PageHandler.check_form) == true
          new_json = data  |> PageHandler.keys_to_atoms

            {:noreply, assign(socket, json_in_levels: json_in_levels,
              json_print: (if val, do: "Data accepted", else: "wrong keys in json"  ),
              resuelveFC_goal: (if val, do: new_json, else: resuelveFC_goal )
              )}
          {:error, _any} ->  {:noreply, assign(socket, json_in_levels: json_in_levels, json_print: "Json data malformed")}
        end

  end



  def handle_event("send_json", _params, socket) do
    json = socket.assigns.json_in |> IO.inspect(label: "New json ?=_============>")
    resuelveFC_goal = socket.assigns.resuelveFC_goal
    json
      |> Poison.decode()
        |> case do
          {:ok, data} ->
            val = data["jugadores"] |> PageHandler.check_form_principal()
            val
            |> case do
              true ->
                result = calculate_total_salary(data, resuelveFC_goal)
                |> Enum.map(fn f -> f |> Map.put("sueldo_completo", f["sueldo_completo"] |>  :erlang.float_to_binary(decimals: 2)) end)
                  {:noreply, assign(socket, json_print: %{"jugadores": result } |> Poison.encode! )}
              false ->
                {:noreply, assign(socket, json_print: "wrong keys in json" )}
            end
          {:error, _any} ->
              {:noreply, assign(socket, json_print: "Error: json malformed")}
        end
  end

  # def handle_event("change_team", _params, socket) do
  #   {:noreply, assign(socket, flag_other_team: true )}
  # end

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
